import 'package:flutter_webrtc/flutter_webrtc.dart';

class AvatarState {

}

class AvatarStateLoading extends AvatarState{}
class AvatarStateData extends AvatarState{
  final String sessionId;
  final RTCPeerConnection peerConnection;

  AvatarStateData({required this.sessionId, required this.peerConnection});
}

sealed class ConnectionStatus {}

class ConnectionStatusWaiting extends ConnectionStatus {}

class ConnectionStatusConnected extends ConnectionStatus {}

class ConnectionStatusError extends ConnectionStatus {}