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
    apiKey: 'AIzaSyDGZ9gbfsY1GUKQX75fDK8zMK1CqXv8wVE',
    appId: '1:108464348168:web:a748435eec62baf13b05bd',
    messagingSenderId: '108464348168',
    projectId: 'eureport-b3f75',
    authDomain: 'eureport-b3f75.firebaseapp.com',
    storageBucket: 'eureport-b3f75.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAqyT5Ai_p6KBu58U19nIns9CnBBIDwgo8',
    appId: '1:108464348168:android:bef6dd79c49606b63b05bd',
    messagingSenderId: '108464348168',
    projectId: 'eureport-b3f75',
    storageBucket: 'eureport-b3f75.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAgDbBMhEG3h0U7Owb38mGVgS1i9PqUS5s',
    appId: '1:108464348168:ios:7715e9af20cb058e3b05bd',
    messagingSenderId: '108464348168',
    projectId: 'eureport-b3f75',
    storageBucket: 'eureport-b3f75.firebasestorage.app',
    iosBundleId: 'com.example.eureportApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAgDbBMhEG3h0U7Owb38mGVgS1i9PqUS5s',
    appId: '1:108464348168:ios:7715e9af20cb058e3b05bd',
    messagingSenderId: '108464348168',
    projectId: 'eureport-b3f75',
    storageBucket: 'eureport-b3f75.firebasestorage.app',
    iosBundleId: 'com.example.eureportApp',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyDGZ9gbfsY1GUKQX75fDK8zMK1CqXv8wVE',
    appId: '1:108464348168:web:0051ed1fc0f145a23b05bd',
    messagingSenderId: '108464348168',
    projectId: 'eureport-b3f75',
    authDomain: 'eureport-b3f75.firebaseapp.com',
    storageBucket: 'eureport-b3f75.firebasestorage.app',
  );
}
