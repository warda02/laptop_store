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
        return macos;
      case TargetPlatform.windows:
        return windows;
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
    apiKey: 'AIzaSyD-wFtMZYCaUvDwIcs4hMM6vpkbljDZkT0',
    appId: '1:947576782316:web:e978cf27d744a437bcd4c9',
    messagingSenderId: '947576782316',
    projectId: 'laptopharbor-b8cf0',
    authDomain: 'laptopharbor-b8cf0.firebaseapp.com',
    storageBucket: 'laptopharbor-b8cf0.appspot.com',
    measurementId: 'G-KFMLJWH55K',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBqB65lSuP2FIUoYX2v4wUTrN3E8wUMze4',
    appId: '1:947576782316:android:5b61c1bc30fb5f5dbcd4c9',
    messagingSenderId: '947576782316',
    projectId: 'laptopharbor-b8cf0',
    storageBucket: 'laptopharbor-b8cf0.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBdH5EYzUDGgJGj4p1qBPsEMEtuN6ym9bU',
    appId: '1:947576782316:ios:fd3749785206dae0bcd4c9',
    messagingSenderId: '947576782316',
    projectId: 'laptopharbor-b8cf0',
    storageBucket: 'laptopharbor-b8cf0.appspot.com',
    iosBundleId: 'com.example.laptopharbor',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBdH5EYzUDGgJGj4p1qBPsEMEtuN6ym9bU',
    appId: '1:947576782316:ios:fd3749785206dae0bcd4c9',
    messagingSenderId: '947576782316',
    projectId: 'laptopharbor-b8cf0',
    storageBucket: 'laptopharbor-b8cf0.appspot.com',
    iosBundleId: 'com.example.laptopharbor',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyD-wFtMZYCaUvDwIcs4hMM6vpkbljDZkT0',
    appId: '1:947576782316:web:799eb134e00f23cabcd4c9',
    messagingSenderId: '947576782316',
    projectId: 'laptopharbor-b8cf0',
    authDomain: 'laptopharbor-b8cf0.firebaseapp.com',
    storageBucket: 'laptopharbor-b8cf0.appspot.com',
    measurementId: 'G-1J95G4CJB9',
  );
}
