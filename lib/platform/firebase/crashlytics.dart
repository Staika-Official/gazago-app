import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';

Future<void> initCrashlytics() async {
  FlutterError.onError = (errorDetails) {
    FirebaseCrashlytics.instance.recordFlutterError(errorDetails, fatal: true);
  };
  await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
}

void recordCrashlyticsError(error, stack) {
  FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
}
