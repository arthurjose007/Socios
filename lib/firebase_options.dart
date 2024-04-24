// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
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
        return macos;
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
    apiKey: 'AIzaSyB5iV3TTWoeasRsnhz00yMdP1gxEYPjRBo',
    appId: '1:319171046007:web:1c374ad314742030adf472',
    messagingSenderId: '319171046007',
    projectId: 'socio-c819c',
    authDomain: 'socio-c819c.firebaseapp.com',
    storageBucket: 'socio-c819c.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAaFhf2NV-UXald-vNGzohKr0SpF6xSPoc',
    appId: '1:319171046007:android:4d2b1a30ddde6f05adf472',
    messagingSenderId: '319171046007',
    projectId: 'socio-c819c',
    storageBucket: 'socio-c819c.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDyk7yPbneGQrQ5H2Y_DxXM3bFUT08AbiM',
    appId: '1:319171046007:ios:d982046811c02ff4adf472',
    messagingSenderId: '319171046007',
    projectId: 'socio-c819c',
    storageBucket: 'socio-c819c.appspot.com',
    iosBundleId: 'com.example.socios',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDyk7yPbneGQrQ5H2Y_DxXM3bFUT08AbiM',
    appId: '1:319171046007:ios:d450264a345d3fa4adf472',
    messagingSenderId: '319171046007',
    projectId: 'socio-c819c',
    storageBucket: 'socio-c819c.appspot.com',
    iosBundleId: 'com.example.socios.RunnerTests',
  );
}
