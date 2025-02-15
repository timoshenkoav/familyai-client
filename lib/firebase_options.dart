// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDFBbdpw_OIMXhcoNMsWPAky3CIxdYNXEs',
    appId: '1:351315350105:web:ffcd8626d96ec21a8f9748',
    messagingSenderId: '351315350105',
    projectId: 'familyai-9faa0',
    authDomain: 'familyai-9faa0.firebaseapp.com',
    storageBucket: 'familyai-9faa0.appspot.com',
    measurementId: 'G-9QXFJTBYSD',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDsWGsYSe5ncoE2s7jtIs35mthOTuk_TxA',
    appId: '1:351315350105:android:433a2e33fa856dbb8f9748',
    messagingSenderId: '351315350105',
    projectId: 'familyai-9faa0',
    storageBucket: 'familyai-9faa0.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAezwiIMolodMS-XLfePiXRSVSL-wkfigE',
    appId: '1:351315350105:ios:96483b32dce151d58f9748',
    messagingSenderId: '351315350105',
    projectId: 'familyai-9faa0',
    storageBucket: 'familyai-9faa0.appspot.com',
    iosBundleId: 'com.familyai.mobile.familyai',
  );
}
