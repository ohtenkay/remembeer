// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, TargetPlatform;

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
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBVYcIo7iPS83hXDihx09UxFn6Qjj7wcHs',
    appId: '1:578025081321:android:525b595153a0315609a378',
    messagingSenderId: '578025081321',
    projectId: 'remembeer-pivo',
    storageBucket: 'remembeer-pivo.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBnXpUk8yKAViMXy89d2tnfm6_MDS-QT9w',
    appId: '1:578025081321:ios:097d191c3409fb4c09a378',
    messagingSenderId: '578025081321',
    projectId: 'remembeer-pivo',
    storageBucket: 'remembeer-pivo.firebasestorage.app',
    iosBundleId: 'com.example.remembeer',
  );
}
