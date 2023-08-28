import 'dart:async';

import 'package:adjust_sdk/adjust.dart';
import 'package:adjust_sdk/adjust_config.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gaza_go/constants/enums.dart';
import 'package:gaza_go/flavors.dart';
import 'package:gaza_go/platform/controllers/global_controller.dart';
import 'package:gaza_go/platform/controllers/loader_controller.dart';
import 'package:gaza_go/platform/firebase/core.dart';
import 'package:gaza_go/platform/firebase/crashlytics.dart';
import 'package:gaza_go/platform/stores/hive_store.dart';
import 'package:gaza_go/presentations/styles/colors.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:uuid/uuid.dart';

import 'constants/routes.dart';

// @pragma('vm:entry-point')
// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   print('call _firebaseMessagingBackgroundHandler');
//   await initFirebase();
//   print('call 1');
//   await backgroundFcm();
//   print('call 2');
//   print('_firebaseMessagingBackgroundHandler $message');
//
//   //TODO. message 처리 필요
// }

Future<PermissionStatus> requestNotificationPermission() async {
  return await Permission.notification.request();
}

void initDebuggingMode() {
  HiveStore.save(key: HiveKey.isDebuggingMode.name, value: false);
  HiveStore.save(key: HiveKey.requestLogs.name, value: []);
  HiveStore.save(key: HiveKey.userExerciseDataLogs.name, value: []);
  HiveStore.save(key: HiveKey.positionRawDataLogs.name, value: []);
  HiveStore.save(key: HiveKey.responseErrorLogs.name, value: []);
}

void main() async {
  await runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized(); // async로 할 때 반드시 호출
    AdjustConfig config = new AdjustConfig('{YourAppToken}', F.isDev ? AdjustEnvironment.sandbox : AdjustEnvironment.production);
    Adjust.start(config);
    await Hive.initFlutter();
    HiveStore.registerAdapters();
    await HiveStore.openBox();

    initDebuggingMode();
    await initFirebase();
    await initFirebasePackages();

    MobileAds.instance.initialize();
    // Geolocation Engine이 2개가 생성되는 문제가 있어서(2개가 생성되면 Foreground 운동측정이 사라지지 않는다). 주석처리
    // 추후에 백그라운드 데이터로 처리가 필요한 경우 다시 고민해보자.
    // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    String? uuid = HiveStore.loadString(key: HiveKey.uuid.name);
    if (uuid == null || uuid.isEmpty) {
      HiveStore.save(key: HiveKey.uuid.name, value: const Uuid().v4());
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
    MaterialColor gazagoColor = MaterialColor(
      0xFF0EE6F3,
      <int, Color>{
        50: skyBlueColor,
        100: skyBlueColor,
        200: skyBlueColor,
        300: skyBlueColor,
        400: skyBlueColor,
        500: skyBlueColor,
        600: skyBlueColor,
        700: skyBlueColor,
        800: skyBlueColor,
        900: skyBlueColor,
      },
    );

    Get.put(GlobalController(), permanent: true);
    Get.put(LoaderController(), permanent: true);

    return ScreenUtilInit(
      designSize: const Size(390, 844),
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
                  child: child!),
            );
          },
          theme: ThemeData(
            fontFamily: 'Pretendard',
            primarySwatch: gazagoColor,
            navigationBarTheme: NavigationBarThemeData(
              elevation: 0,
              indicatorColor: Colors.transparent,
              labelTextStyle: MaterialStateProperty.resolveWith((states) {
                if (states.contains(MaterialState.selected)) {
                  return TextStyle(
                    color: skyBlueColor,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  );
                }

                return TextStyle(
                  color: lightGrayColor,
                  fontSize: 10,
                  wordSpacing: 0,
                  fontWeight: FontWeight.w600,
                );
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
