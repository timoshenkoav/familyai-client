import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:familyai/di/service_locator.dart';
import 'package:familyai/domain/repo/api_repository.dart';
import 'package:familyai/domain/repo/avatar_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:logger/logger.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import 'event.dart';
import 'state.dart';

class AvatarBloc extends Bloc<AvatarEvent, AvatarState> {
  final String avatarId;
  final Logger logger = getIt();
  late RTCVideoRenderer remoteRenderer;
  final text = TextEditingController();
  final processing = ValueNotifier(false);
  final threadId = ValueNotifier("");
  final connected = ValueNotifier<ConnectionStatus>(ConnectionStatusWaiting());

  WebSocketChannel? channel;
  final subs = <StreamSubscription>[];
  final AvatarRepository _avatarRepository = getIt();

  AvatarBloc(this.avatarId) : super(AvatarStateLoading()) {
    remoteRenderer = RTCVideoRenderer();
    logDebug("create $remoteRenderer");
    on<InitEvent>(_init);
    on<StateEvent>(_state);
    add(InitEvent());
  }

  @override
  Future<void> close() async {
    for (var element in subs) {
      element.cancel();
    }
    subs.clear();
    final channel = this.channel;
    if (channel != null) {
      channel.sink.close();
    }
    await stopSession();
    logDebug("dispose $remoteRenderer");
    remoteRenderer.dispose();
    this.channel = null;
    return super.close();
  }

  void _state(StateEvent event, Emitter<AvatarState> emit) async {
    emit(event.state);
  }

  void _sendCreate(WebSocketChannel channel) {
    channel.sink.add(jsonEncode({"command": "create", "avatarId": avatarId}));
  }

  void _sendStart(WebSocketChannel channel, String sessionId, dynamic topic) {
    channel.sink.add(jsonEncode(
        {"command": "start", "sessionId": sessionId, "topic": topic}));
  }

  void _init(InitEvent event, Emitter<AvatarState> emit) async {
    logDebug("AvatarBloc init");
    await remoteRenderer.initialize();

    var uri = Uri.parse("${socketApiUrl()}/ws/global");
    final channel = WebSocketChannel.connect(uri);
    subs.add(channel.stream.listen(
      (eventData) async {
        logger.d("event received $eventData");
        final event = jsonDecode(eventData);
        final String type = event["type"];
        if (type == "respond-start") {
          processing.value = true;
        } else if (type == "respond-stop") {
          processing.value = false;
        } else if (type == "session-created") {
          final data = event["data"];
          final topic = data["topic"];

          final String sessionId = await _connectWebRtc(channel);
          _sendStart(channel, sessionId, topic);
        } else if (type == "start-success"){
          final data = event["data"];
          final threadId = data["threadId"];
          this.threadId.value = threadId;
          processing.value = false;
        }
      },
    ));
    channel.sink.done.then((value) {
      connected.value = ConnectionStatusError();
      logger.d("done completed $value");
      this.channel = null;
    }, onError: (error) {
      connected.value = ConnectionStatusError();
      this.channel = null;
      logger.d("done error $error");
    });
    channel.ready.then((value) async {
      logger.d("connected");
      this.channel = channel;
      connected.value = ConnectionStatusConnected();
      _sendCreate(channel);
    }, onError: (ex, stack) {
      connected.value = ConnectionStatusError();
      this.channel = null;
      logger.d("ready error $ex $stack");
    });
  }

  Future<String> _connectWebRtc(WebSocketChannel channel) async {
    final resp = await _avatarRepository.createSession();
    logDebug("session $resp");
    final sdp = resp["sdp"];
    final sessionId = resp["session_id"];
    final ice_servers2 = resp["ice_servers2"];
    final peerConnection =
        await createPeerConnection({"iceServers": ice_servers2});
    peerConnection.onAddTrack = (stream, track) {
      logDebug("onAddTrack ${stream} ${track}");
    };

    peerConnection.onAddStream = (stream) {
      remoteRenderer.srcObject = stream;
      logDebug("onAddStream $remoteRenderer");
    };
    peerConnection.onTrack = (event) {
      logDebug("onTrack $remoteRenderer ${event.track.kind}");
      if (event.track.kind == "video" || event.track.kind == "audio") {
        remoteRenderer.srcObject = event.streams[0];
      }
    };

    peerConnection.onConnectionState = (state) {
      logDebug("onConnectionState $state");
    };
    peerConnection.onIceCandidate = (candidate) {
      logDebug("onIceCandidate $candidate");
      _avatarRepository.handleIce(sessionId, candidate.toMap());
    };
    peerConnection.onIceConnectionState = (state) {
      logDebug("onIceConnectionState $state");
    };
    peerConnection.onDataChannel = (event) {
      logDebug("onDataChannel");
    };

    final remoteDesc = RTCSessionDescription(sdp["sdp"], sdp["type"]);
    await peerConnection.setRemoteDescription(remoteDesc);

    final localDescription = await peerConnection.createAnswer();
    await peerConnection.setLocalDescription(localDescription);

    await _avatarRepository.startSession(sessionId, localDescription.toMap());

    add(StateEvent(
        state: AvatarStateData(
            sessionId: sessionId, peerConnection: peerConnection)));

    return sessionId;
  }

  Future<void> stopSession() async {
    final state = this.state;
    if (state is AvatarStateData) {
      await _avatarRepository.stopSession(state.sessionId);
      await state.peerConnection.close();
    }
  }

  void repeat() {
    final state = this.state;
    if (state is AvatarStateData) {
      Future.microtask(() {
        channel?.sink.add(jsonEncode({
          "command": "message",
          "text": text.text,
          "sessionId": state.sessionId,
          "threadId": threadId.value
        }));
      });
      processing.value = true;
    }
  }
}
