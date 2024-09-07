import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:familyai/di/service_locator.dart';

const String SERVER_URL = "https://api.heygen.com";
const String API_KEY =
    "MDRjODg5ZGFlZDg1NDQ1MGJiOTM2YjhkZWIyNmVhMjAtMTcyNTUyMDI1Mg==";

class AvatarRepository {
  final dio = getIt<Dio>();
  final options = Options(headers: {
    "X-Api-Key": API_KEY,
  });

  Future<void> closeSessions() async {
    try {
      final listResp =
          await dio.get("$SERVER_URL/v1/streaming.list", options: options);
      final list = jsonDecode(listResp.data)["data"]["sessions"];
      for (dynamic elem in list) {
        final id = elem["session_id"];
        final resp = await dio.post("$SERVER_URL/v1/streaming.stop",
            data: {"session_id": id}, options: options);
      }
    } catch (ex, stack) {
      logDebug(ex);
    }
  }

  Future<dynamic> handleIce(String id, dynamic candidate) async {
    final resp = await dio.post(
        "$SERVER_URL/v1/streaming.ice",
        data: {
          "session_id":id,
          "candidate": candidate
        },
        options: options
    );
  }
  Future<dynamic> startSession(String id, dynamic sdp) async {
    final resp = await dio.post(
        "$SERVER_URL/v1/streaming.start",
        data: {
          "session_id":id,
          "sdp": sdp
        },
        options: options
    );
  }

  Future<dynamic> createSession() async {
    await closeSessions();
    final resp = await dio.post("$SERVER_URL/v1/streaming.new",
        data: {
          "quality": "low",
          "avatar": "Anna_public_3_20240108",
          "voice": {"voice_id": "131a436c47064f708210df6628ef8f32"},
        },
        options: options);
    return jsonDecode(resp.data)["data"];
  }

  void repeat(String sessionId, String text) async{
    final resp = await dio.post("$SERVER_URL/v1/streaming.task",
        data: {
          "session_id": sessionId,
          "text": text,
          "task_type": "repeat",
        },
        options: options);
  }

  Future<void> stopSession(String sessionId) async{
    final resp = await dio.post("$SERVER_URL/v1/streaming.stop",
        data: {
          "session_id": sessionId,
        },
        options: options);
  }
}
