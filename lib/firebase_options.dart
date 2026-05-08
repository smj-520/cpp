// Generated from android/app/google-services.json (project b-tech-6c069).
// Run `dart run flutterfire configure` later to regenerate for all platforms.

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError(
        'Web Firebase options are not configured. Use flutterfire configure.',
      );
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'Add GoogleService-Info.plist and run flutterfire configure for Apple platforms.',
        );
      default:
        throw UnsupportedError(
          'This app only initializes Firebase on Android in firebase_options.dart.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAS1KOYlC496ivN1lp-AeOL1b_n0yRDySY',
    appId: '1:289293783451:android:09be5aed32a5e316e9913e',
    messagingSenderId: '289293783451',
    projectId: 'b-tech-6c069',
    storageBucket: 'b-tech-6c069.firebasestorage.app',
  );
}
