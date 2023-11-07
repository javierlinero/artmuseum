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
    apiKey: 'AIzaSyBGd6OPFgdWRHMZonHYnfgJUS5CapzbLtg',
    appId: '1:687518361518:web:798636c410c732b0528a3f',
    messagingSenderId: '687518361518',
    projectId: 'puam-d9006',
    authDomain: 'puam-d9006.firebaseapp.com',
    storageBucket: 'puam-d9006.appspot.com',
    measurementId: 'G-3YDM8T98EX',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAKGZ2wIXSMjj5rHc1wHyrTVtkSQAmCFtE',
    appId: '1:687518361518:android:352294307c747e3e528a3f',
    messagingSenderId: '687518361518',
    projectId: 'puam-d9006',
    storageBucket: 'puam-d9006.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDaO8CNUEH72bZGsxTXsO7M6CIp3-452FI',
    appId: '1:687518361518:ios:21fe9db523ea0444528a3f',
    messagingSenderId: '687518361518',
    projectId: 'puam-d9006',
    storageBucket: 'puam-d9006.appspot.com',
    iosBundleId: 'com.example.puamApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDaO8CNUEH72bZGsxTXsO7M6CIp3-452FI',
    appId: '1:687518361518:ios:dea0f9794ffd0a76528a3f',
    messagingSenderId: '687518361518',
    projectId: 'puam-d9006',
    storageBucket: 'puam-d9006.appspot.com',
    iosBundleId: 'com.example.puamApp.RunnerTests',
  );
}