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
    apiKey: 'AIzaSyDJ4Ih45v8qLbffr5p8fVaELEBpCdxb8zQ',
    appId: '1:211414070664:web:2cbe39e50e2563c9f8363d',
    messagingSenderId: '211414070664',
    projectId: 'flutter-mad-project-bc75a',
    authDomain: 'flutter-mad-project-bc75a.firebaseapp.com',
    storageBucket: 'flutter-mad-project-bc75a.appspot.com',
    measurementId: 'G-MP8CZL5TWX',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAEROJJ3TbkQZHmHqOyDPTGEme2_x5LAFQ',
    appId: '1:211414070664:android:93bd29ba6735cc3ef8363d',
    messagingSenderId: '211414070664',
    projectId: 'flutter-mad-project-bc75a',
    storageBucket: 'flutter-mad-project-bc75a.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBO9aHpVb2ZCG8YWNKtsSLhoOYn5kwSbOs',
    appId: '1:211414070664:ios:28d4a5b9ace26583f8363d',
    messagingSenderId: '211414070664',
    projectId: 'flutter-mad-project-bc75a',
    storageBucket: 'flutter-mad-project-bc75a.appspot.com',
    iosBundleId: 'com.example.seProject',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBO9aHpVb2ZCG8YWNKtsSLhoOYn5kwSbOs',
    appId: '1:211414070664:ios:8b1f49de6cbc6c16f8363d',
    messagingSenderId: '211414070664',
    projectId: 'flutter-mad-project-bc75a',
    storageBucket: 'flutter-mad-project-bc75a.appspot.com',
    iosBundleId: 'com.example.seProject.RunnerTests',
  );
}
