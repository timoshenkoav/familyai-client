
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:familyai/domain/repo/api_repository.dart';
import 'package:familyai/domain/repo/avatar_repository.dart';
import 'package:familyai/domain/repo/members_repository.dart';
import 'package:familyai/domain/repo/user_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';

final getIt = GetIt.instance;
class PlatformOpts{
  static final PlatformOpts _instance = PlatformOpts();
  static PlatformOpts get instance => _instance;
  bool isWide(BuildContext context){
    final width = MediaQuery.of(context).size.width;
    final wide = width > 700;
    return wide && kIsWeb;
  }
  bool isAndroid(){
    if (kIsWeb){
      return false;
    }
    return Platform.isAndroid;
  }

  bool purchasesAvailable() {
    return isIOS() || isAndroid();
  }

  bool shareAvailable(){
    return isAndroid() || isIOS();
  }

  bool isIOS(){
    if (kIsWeb){
      return false;
    }
    return Platform.isIOS;
  }
  bool isWeb(){
    return kIsWeb;
  }
}

class AppOutput extends LogOutput {
  @override
  void output(OutputEvent event) {
    for (var element in event.lines) {
      debugPrint("Doublee ${element.length}: $element",wrapWidth: 500);
      // print("Doublee ${element.length}: $element");
    }
  }
}
class AppFilter extends LogFilter {
  @override
  bool shouldLog(LogEvent event) {
    return true;
  }
}

void logDebug(dynamic message){
  Logger logger = getIt();
  logger.d(message);
}

Future<void> setupLocator() async {
  var logger = Logger(
      printer: SimplePrinter(),
      filter: AppFilter(),
      level: Level.debug,
      output: AppOutput());
  getIt.registerSingleton(logger);

  final dio = Dio();
  dio.interceptors.add(
    LogInterceptor(
      requestBody: true,
      responseBody: true,
      logPrint: (o) => logger.d(o),
    ),
  );
  getIt.registerSingleton(dio);
  getIt.registerSingleton(ApiRepository());
  getIt.registerSingleton(UserRepository());
  getIt.registerSingleton(AvatarRepository());
  getIt.registerSingleton(MembersRepository());
}
