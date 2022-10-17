import 'package:gaza_go/platform/firebase/cloud_messaging.dart';
import 'package:gaza_go/platform/firebase/crashlytics.dart';
import 'package:gaza_go/platform/firebase/dynamic_link.dart';
import 'package:gaza_go/platform/firebase/firebase_options.dart';
import 'package:gaza_go/platform/firebase/remote_config.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> initFirebase() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}

Future<void> initFirebasePackages() async {
  await initDynamicLink();
  await initCrashlytics();
  await initRemoteConfig();
  await initFcm();
}

Future<void> backgroundFcm() async {
  await setForegroundConfig();
}
