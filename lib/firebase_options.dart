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
    apiKey: 'AIzaSyBc8GpVxvTjMRT2hHg0um-elaeeGu1Ms9c',
    appId: '1:998077547144:web:af9ccec011dd5dc2f8953d',
    messagingSenderId: '998077547144',
    projectId: 'chat-91f83',
    authDomain: 'chat-91f83.firebaseapp.com',
    storageBucket: 'chat-91f83.appspot.com',
    measurementId: 'G-VNXK2X632Y',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyABFjRmpHom1upzMWIvdwb9UySzuFHOazw',
    appId: '1:998077547144:android:0c079631bde05faef8953d',
    messagingSenderId: '998077547144',
    projectId: 'chat-91f83',
    storageBucket: 'chat-91f83.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDypTmYoCOfPogPR4xk7bFx2KH7RfvlCDI',
    appId: '1:998077547144:ios:74f3f1c0710d1da8f8953d',
    messagingSenderId: '998077547144',
    projectId: 'chat-91f83',
    storageBucket: 'chat-91f83.appspot.com',
    iosBundleId: 'com.example.chatApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDypTmYoCOfPogPR4xk7bFx2KH7RfvlCDI',
    appId: '1:998077547144:ios:8a6a04fac2b1c305f8953d',
    messagingSenderId: '998077547144',
    projectId: 'chat-91f83',
    storageBucket: 'chat-91f83.appspot.com',
    iosBundleId: 'com.example.chatApp.RunnerTests',
  );
}
