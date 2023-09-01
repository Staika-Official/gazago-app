import 'package:firebase_core/firebase_core.dart';
import 'package:gaza_go/platform/firebase/cloud_messaging.dart';
import 'package:gaza_go/platform/firebase/crashlytics.dart';
import 'package:gaza_go/platform/firebase/firebase_options.dart';
import 'package:gaza_go/platform/firebase/remote_config.dart';

Future<void> initFirebase() async {
  await Firebase.initializeApp(
    name: 'gazaGo',
    options: DefaultFirebaseOptions.currentPlatform,
  );
}

Future<void> initFirebasePackages() async {
  await initCrashlytics();
  await initRemoteConfig();
  await initFcm();
}

Future<void> backgroundFcm() async {
  await setForegroundConfig();
}
