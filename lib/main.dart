import 'dart:async';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:step_go/platform/firebase/core.dart';
import 'package:step_go/platform/firebase/crashlytics.dart';

import 'constants/routes.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await initFirebase();

  //TODO. message 처리 필요
}

void main() async {
  await runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized(); // async로 할 때 반드시 호출
    await Hive.initFlutter();
    await initFirebase();
    await initFirebasePackages();
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    runApp(MyApp());
  }, (error, stack) {
    recordCrashlyticsError(error, stack);
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  static FirebaseAnalyticsObserver observer = FirebaseAnalyticsObserver(analytics: analytics);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      builder: (context, child) {
        // 시스템 폰트 크기 무시
        return MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaleFactor: 1), //텍스트가 시스템 설정에 영향받지 않음
            child: child!);
      },
      theme: ThemeData(
        fontFamily: 'Pretendard',
        primarySwatch: Colors.blue,
      ),
      navigatorObservers: <NavigatorObserver>[observer],
      initialRoute: Routes.home,
      getPages: [...Routes.pages],
    );
  }
}
