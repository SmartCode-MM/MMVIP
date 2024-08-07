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
    apiKey: 'AIzaSyA9RuAHkNC-h28xkvCCJxilUSudNH6I8kM',
    appId: '1:760132802717:web:ace87ea9dc041c2b265c74',
    messagingSenderId: '760132802717',
    projectId: 'mmvip-fc109',
    authDomain: 'mmvip-fc109.firebaseapp.com',
    storageBucket: 'mmvip-fc109.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAGHF3-qedKRSfH14n5i8WfyRaD90VaYf0',
    appId: '1:760132802717:android:826448c04150c2c7265c74',
    messagingSenderId: '760132802717',
    projectId: 'mmvip-fc109',
    storageBucket: 'mmvip-fc109.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAixdGSxkzUIp6KyERehD9zzFHLpMx5RWM',
    appId: '1:760132802717:ios:e8a2c4cb4a6b5e93265c74',
    messagingSenderId: '760132802717',
    projectId: 'mmvip-fc109',
    storageBucket: 'mmvip-fc109.appspot.com',
    androidClientId: '760132802717-4sdg9mcrni3m5h2v6eanq54ns3gfildo.apps.googleusercontent.com',
    iosClientId: '760132802717-virep2nvde1f92oa8ua3c74500e484ru.apps.googleusercontent.com',
    iosBundleId: 'com.example.mmvip',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAixdGSxkzUIp6KyERehD9zzFHLpMx5RWM',
    appId: '1:760132802717:ios:9b317bf7e38b17fa265c74',
    messagingSenderId: '760132802717',
    projectId: 'mmvip-fc109',
    storageBucket: 'mmvip-fc109.appspot.com',
    androidClientId: '760132802717-4sdg9mcrni3m5h2v6eanq54ns3gfildo.apps.googleusercontent.com',
    iosClientId: '760132802717-vchp60qiks9tft30128tn2qp3qq361tf.apps.googleusercontent.com',
    iosBundleId: 'com.example.mmvip.RunnerTests',
  );
}
