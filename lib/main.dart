import 'package:familyai/di/service_locator.dart';
import 'package:familyai/firebase_options.dart';
import 'package:familyai/ui/cb_app/view.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:qlevar_router/qlevar_router.dart';

void main() async{
  final binding = WidgetsFlutterBinding.ensureInitialized();
  QR.setUrlStrategy();
  // FlutterError.onError = (errorDetails) {
  //
  // };
  // PlatformDispatcher.instance.onError = (error, stack) {
  //   return true;
  // };
  await setupLocator();
  await _initFirebase();
  runApp(const RootPage());
}

class RootPage extends StatelessWidget {
  const RootPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const CbAppPage();
  }
}

Future<void> _initFirebase() async {
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    final remoteConfig = FirebaseRemoteConfig.instance;
    await remoteConfig.setConfigSettings(RemoteConfigSettings(
      fetchTimeout: const Duration(minutes: 1),
      minimumFetchInterval: const Duration(hours: 1),
    ));
    if (kDebugMode && !kIsWeb) {
      await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(false);
    }
  } catch (ex) {
    print(ex);
  }
}