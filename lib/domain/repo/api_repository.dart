import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:familyai/di/service_locator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:logger/logger.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

const String apiDomain =
    String.fromEnvironment("API_DOMAIN", defaultValue: "192.168.3.8");
const String apiPort = String.fromEnvironment("API_PORT", defaultValue: "");
const String socketPort =
    String.fromEnvironment("SOCKET_PORT", defaultValue: "");
const bool isSecure = int.fromEnvironment("SECURE", defaultValue: 1) == 1;

String baseApiUrl() {
  String scheme = isSecure ? "https" : "http";
  String port = apiPort.isEmpty ? "" : ":$apiPort";
  return "$scheme://$apiDomain$port";
}

String socketApiUrl() {
  String scheme = isSecure ? "wss" : "ws";
  String port = socketPort.isEmpty ? "" : ":$socketPort";
  return "$scheme://$apiDomain$port";
}

class ApiRepository {
  final Dio dio = getIt();

  Future<Options> _authOptions() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final token = await user.getIdToken();
      return Options(headers: {
        "Authorization": "Bearer $token",
      });
    }

    return Options();
  }

  Future<dynamic> profile() async {
    final resp = await dio.get("${baseApiUrl()}/api/profile",
        options: await _authOptions());
    return resp.data;
  }

  Future<List<dynamic>> topics() async {
    final resp = await dio.get("${baseApiUrl()}/api/topics",
        options: await _authOptions());
    return resp.data;
  }
  Future<List<dynamic>> roles() async {
    final resp = await dio.get("${baseApiUrl()}/api/roles",
        options: await _authOptions());
    return resp.data;
  }

  Future<void> connect() async {
    // return new GlobalConnection(channel: channel);
  }

  Future<bool> updateProfile({
    String? firstName,
    String? lastName,
  }) async {
    final resp = await dio.post("${baseApiUrl()}/api/profile",
        data: {"firstName": firstName, "lastName": lastName},
        options: await _authOptions());
    return resp.statusCode == 200;
  }

  Future<bool> createMember(
      String firstName, String lastName, String email, topic, role) async {
    final resp = await dio.post("${baseApiUrl()}/api/members",
        data: {
          "firstName": firstName,
          "lastName": lastName,
          "email": email,
          "roleId": role["id"],
          "topicId": topic["id"]
        },
        options: await _authOptions());
    return resp.statusCode == 200;
  }

  Future<List<dynamic>> members() async {
    final resp = await dio.get("${baseApiUrl()}/api/members",
        options: await _authOptions());
    return resp.data;
  }
}
