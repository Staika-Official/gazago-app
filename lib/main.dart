import 'dart:async';

import 'package:adjust_sdk/adjust.dart';
import 'package:adjust_sdk/adjust_config.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'generated/codegen_loader.g.dart';
import 'package:gaza_go/constants/enums.dart';
import 'package:gaza_go/flavors.dart';
import 'package:gaza_go/platform/controllers/activity_controller.dart';
import 'package:gaza_go/platform/controllers/global_controller.dart';
import 'package:gaza_go/platform/controllers/loader_controller.dart';
import 'package:gaza_go/platform/controllers/wallet_master_controller.dart';
import 'package:gaza_go/platform/configs/unified_gps_config.dart';
import 'package:gaza_go/platform/helpers/gps_helper.dart' as gps_helper;
import 'package:gaza_go/platform/firebase/core.dart';
import 'package:gaza_go/platform/firebase/crashlytics.dart';
import 'package:gaza_go/platform/helpers/login_helper.dart';
import 'package:gaza_go/platform/stores/hive_store.dart';
import 'package:gaza_go/presentations/components/alert_ui_list.dart';
import 'package:gaza_go/presentations/styles/colors.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:kakao_flutter_sdk_share/kakao_flutter_sdk_share.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:uuid/uuid.dart';
import 'package:easy_localization/easy_localization.dart';

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

const supportedLocales = [Locale('en', 'US'), Locale('ko', 'KR')];

Future<PermissionStatus> requestNotificationPermission() async {
  return await Permission.notification.request();
}

Future<PermissionStatus> requestTrackingPermission() async {
  return await Permission.appTrackingTransparency.request();
}

void initDebuggingMode() {
  HiveStore.save(key: HiveKey.isDebuggingMode.name, value: false);
  HiveStore.save(key: HiveKey.requestLogs.name, value: []);
  HiveStore.save(key: HiveKey.userExerciseDataLogs.name, value: []);
  HiveStore.save(key: HiveKey.positionRawDataLogs.name, value: []);
  HiveStore.save(key: HiveKey.responseErrorLogs.name, value: []);
}

Future<void> initializeAdMob() async {
  await MobileAds.instance.initialize().then((initializationStatus) {
    // isAdmobPluginInitialized.value = true;
    initializationStatus.adapterStatuses.forEach((key, value) {
      debugPrint('Adapter status for $key: ${value.description}');
    });
  });
}

void getStreamData(snapshot) async {
  print(snapshot.value);
  HiveStore.save(key: HiveKey.serviceStatus.name, value: snapshot.value);
  if (Get.currentRoute == Routes.login &&
      (Get.isDialogOpen! || Get.isBottomSheetOpen!)) {
    Get.back();
  }
  if (snapshot.value == 2) {
    forceLogout();
    Future.delayed(const Duration(seconds: 1), () async {
      if (!Get.isDialogOpen!) {
        showServiceInspectionNotice();
      }
    });

    return;
  } else if (snapshot.value == 1) {
    Future.delayed(const Duration(seconds: 1), () async {
      if (Get.currentRoute == Routes.login && !Get.isDialogOpen!) {
        showServiceInspectionNotice();
      }
    });
    return;
  } else {}
}

Future<void> checkInspectionNotice() async {
  DatabaseReference inspectionNoticeRef =
      FirebaseDatabase.instance.ref('inspection');
  Stream<DatabaseEvent> stream = inspectionNoticeRef.onValue;
  await inspectionNoticeRef.get().then((DataSnapshot snapshot) async {
    getStreamData(snapshot);
  }).onError((error, stackTrace) {
    print(error);
  });
  stream.listen((DatabaseEvent event) {
    print('Event Type: ${event.type}');
    print('Snapshot: ${event.snapshot.value}');
    getStreamData(event.snapshot);
  });
}

Future<void> checkRegion() async {
  String? language = HiveStore.loadString(key: HiveKey.serviceLanguage.name);
  if (language == null) {
    HiveStore.save(key: HiveKey.serviceLanguage.name, value: 'ko');
  }
}

void main() async {
  await runZonedGuarded(() async {
    int isServiceInspection = 0;
    WidgetsFlutterBinding.ensureInitialized(); // async로 할 때 반드시 호출
    await EasyLocalization.ensureInitialized();

    AdjustConfig adjustConfig = new AdjustConfig('egsa3l7qwj5s',
        F.isDev ? AdjustEnvironment.sandbox : AdjustEnvironment.production);
    adjustConfig.logLevel = AdjustLogLevel.verbose;
    Adjust.start(adjustConfig);

    await Hive.initFlutter();
    HiveStore.registerAdapters();
    await HiveStore.openBox();
    KakaoSdk.init(
      nativeAppKey: F.isDev
          ? '930bba5aed33cd931e3f56280a663785'
          : '2e02e4417b2bc7cdecb41b59d6196206',
    );
    await checkRegion();
    initDebuggingMode();
    await initFirebase();
    await initFirebasePackages();
    await initializeAdMob();
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
    await requestTrackingPermission();

    // Initialize UnifiedGPSManager early in app lifecycle
    print('🌍 Initializing Unified GPS System...');
    await UnifiedGPSConfig.initialize();
    // Initialize GPS manager and request permissions
    final gpsPermissionGranted =
        await gps_helper.GPS.checkAndRequestPermissions();
    if (gpsPermissionGranted) {
      print('✅ GPS System initialized with permissions');
    } else {
      print('⚠️ GPS System initialized but permissions not granted');
    }

    await checkInspectionNotice();

    runApp(EasyLocalization(
        assetLoader: const CodegenLoader(),
        supportedLocales: supportedLocales,
        path: 'assets/translations',
        fallbackLocale: const Locale('en', 'US'),
        child: const MyApp()));
  }, (error, stack) {
    recordCrashlyticsError(error, stack);
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  static FirebaseAnalyticsObserver observer =
      FirebaseAnalyticsObserver(analytics: analytics);

  @override
  Widget build(BuildContext context) {
    MaterialColor gazagoColor = const MaterialColor(
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
    Get.put(WalletMasterController(), permanent: true);
    // Get.put(InspectionNoticeController(), permanent: true);
    Get.put(LoaderController(), permanent: true);

    Get.put(ActivityController(), permanent: true);

    return ScreenUtilInit(
      designSize: const Size(390, 844),
      splitScreenMode: true,
      minTextAdapt: true,
      fontSizeResolver: (fontSize, screenUtil) {
        return screenUtil.screenWidth < 400
            ? FontSizeResolvers.width(fontSize, screenUtil)
            : fontSize * screenUtil.scaleText;
      },
      builder: (BuildContext context, Widget? child) {
        return GetMaterialApp(
          builder: (context, child) {
            // 시스템 폰트 크기 무시
            return ScrollConfiguration(
              behavior:
                  const MaterialScrollBehavior().copyWith(overscroll: false),
              child: MediaQuery(
                data: MediaQuery.of(context).copyWith(
                    textScaler:
                        const TextScaler.linear(1)), //텍스트가 시스템 설정에 영향받지 않음
                child: child!,
              ),
            );
          },
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
          fallbackLocale: const Locale('en', 'US'),
          theme: ThemeData(
            fontFamily: 'Pretendard',
            primarySwatch: gazagoColor,
            navigationBarTheme: NavigationBarThemeData(
              elevation: 0,
              indicatorColor: Colors.transparent,
              labelTextStyle: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.selected)) {
                  return const TextStyle(
                    color: skyBlueColor,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  );
                }

                return const TextStyle(
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
