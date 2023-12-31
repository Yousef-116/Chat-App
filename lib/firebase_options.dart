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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for ios - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyCe1ffrc8JJYoEOmu1c5bnJTe31dF_sfzE',
    appId: '1:555319936084:web:76f95d79c1fd1243e1d9c1',
    messagingSenderId: '555319936084',
    projectId: 'nemo-b19da',
    authDomain: 'nemo-b19da.firebaseapp.com',
    storageBucket: 'nemo-b19da.appspot.com',
    measurementId: 'G-GLC9NXRTW2',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyA6jWPNsHytKwBnbAeEHEen2N_M0-eDBsg',
    appId: '1:555319936084:android:8019c97375947939e1d9c1',
    messagingSenderId: '555319936084',
    projectId: 'nemo-b19da',
    storageBucket: 'nemo-b19da.appspot.com',
  );
}
