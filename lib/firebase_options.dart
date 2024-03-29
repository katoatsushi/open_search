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
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
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

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDeaB3giQLvrqwj-lKQTHFdMWk5-4ub_Io',
    appId: '1:931547608270:android:e9a90ac928a89c9e9a0c9f',
    messagingSenderId: '931547608270',
    projectId: 'alpha-398211',
    storageBucket: 'alpha-398211.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCppKjpMVZJLzHrN7uaa2K6oASMZmaTY_4',
    appId: '1:931547608270:ios:99bac3735a6b5f289a0c9f',
    messagingSenderId: '931547608270',
    projectId: 'alpha-398211',
    storageBucket: 'alpha-398211.appspot.com',
    androidClientId: '931547608270-9mo2mlbactceqfjed3t7e6gk798upgfv.apps.googleusercontent.com',
    iosClientId: '931547608270-ctb6skbprdlmp4c54frpqu9rbulighv9.apps.googleusercontent.com',
    iosBundleId: 'com.example.openSearch',
  );
}
