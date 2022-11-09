import 'dart:async';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gaza_go/constants/enums.dart';
import 'package:gaza_go/platform/controllers/global_controller.dart';
import 'package:gaza_go/platform/firebase/core.dart';
import 'package:gaza_go/platform/firebase/crashlytics.dart';
import 'package:gaza_go/platform/stores/hive_store.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:uuid/uuid.dart';

import 'constants/routes.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('call _firebaseMessagingBackgroundHandler');
  await initFirebase();
  print('call 1');
  await backgroundFcm();
  print('call 2');
  print('_firebaseMessagingBackgroundHandler $message');

  //TODO. message 처리 필요
}

Future<PermissionStatus> requestNotificationPermission() async {
  return await Permission.notification.request();
}

void main() async {
  await runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized(); // async로 할 때 반드시 호출
    await Hive.initFlutter();
    HiveStore.registerAdapters();
    await HiveStore.openBox();
    await initFirebase();
    await initFirebasePackages();

    // Geolocation Engine이 2개가 생성되는 문제가 있어서(2개가 생성되면 Foreground 운동측정이 사라지지 않는다). 주석처리
    // 추후에 백그라운드 데이터로 처리가 필요한 경우 다시 고민해보자.
    //FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    String? uuid = HiveStore.loadString(key: HiveKey.uuid.name);
    if (uuid == null || uuid.isEmpty) {
      HiveStore.save(key: HiveKey.uuid.name, value: Uuid().v4());
    }
    await initializeDateFormatting();
    await requestNotificationPermission();

    runApp(const MyApp());
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
    MaterialColor gazagoColor = const MaterialColor(
      0xFF0EE6F3,
      <int, Color>{
        50: Color(0xFF0EE6F3),
        100: Color(0xFF0EE6F3),
        200: Color(0xFF0EE6F3),
        300: Color(0xFF0EE6F3),
        400: Color(0xFF0EE6F3),
        500: Color(0xFF0EE6F3),
        600: Color(0xFF0EE6F3),
        700: Color(0xFF0EE6F3),
        800: Color(0xFF0EE6F3),
        900: Color(0xFF0EE6F3),
      },
    );
    Get.put(GlobalController(), permanent: true);

    return ScreenUtilInit(
      designSize: Size(390, 844),
      splitScreenMode: false,
      minTextAdapt: true,
      builder: (BuildContext context, Widget? child) {
        return GetMaterialApp(
          builder: (context, child) {
            // 시스템 폰트 크기 무시
            return ScrollConfiguration(
              behavior: const MaterialScrollBehavior().copyWith(overscroll: false),
              child: MediaQuery(
                data: MediaQuery.of(context).copyWith(textScaleFactor: 1), //텍스트가 시스템 설정에 영향받지 않음
                child: child!,
              ),
            );
          },
          theme: ThemeData(
            fontFamily: 'Pretendard',
            primarySwatch: gazagoColor,
            navigationBarTheme: NavigationBarThemeData(
              indicatorColor: Colors.transparent,
              labelTextStyle: MaterialStateProperty.resolveWith((states) {
                if (states.contains(MaterialState.selected)) {
                  return const TextStyle(
                    color: Color(0xFF0EE6F3),
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  );
                } else {
                  return const TextStyle(
                    color: Color(0xFFBFBFBF),
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  );
                }
              }),
            ),
          ),
          navigatorObservers: <NavigatorObserver>[observer],
          initialRoute: Routes.login,
          getPages: [...Routes.pages],
        );
      },
    );
  }
}
