import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart' show defaultTargetPlatform, TargetPlatform;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:gaza_go/constants/enums.dart';
import 'package:gaza_go/platform/controllers/activity_controller.dart';
import 'package:gaza_go/platform/controllers/home_menu_controller.dart';
import 'package:gaza_go/platform/controllers/inventory_home_controller.dart';
import 'package:gaza_go/platform/controllers/wallet_master_controller.dart';
import 'package:gaza_go/platform/models/push_message_challenge_success_model.dart';
import 'package:gaza_go/platform/stores/hive_store.dart';
import 'package:gaza_go/presentations/components/alert_ui_list.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

AndroidNotificationChannel channel = const AndroidNotificationChannel(
  'gazago',
  'gazago notifications',
  importance: Importance.high,
);

late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

Future<void> initFcm() async {
  await requestPermission();

  await FirebaseMessaging.instance.getToken().then((fcmToken) async {
    print('fcmToken: $fcmToken');
    if (fcmToken != null && fcmToken.isNotEmpty) {
      HiveStore.save(key: HiveKey.fcmToken.name, value: fcmToken);
    }
  });

  FirebaseMessaging.instance.onTokenRefresh.listen((fcmToken) async {
    if (fcmToken.isNotEmpty) {
      HiveStore.save(key: HiveKey.fcmToken.name, value: fcmToken);
    }
    Logger().i('refresh fcmToken : $fcmToken');
    // Note: 이 콜백은 매번 앱이 실행되거나 새로운 토큰이 생성되었을 때 실행된다.
  }).onError((err) {
    Logger().e('onTokenRefreshErr $err');
  });

  await setForegroundConfig();
  handleMessage();
}

void handleMessage() {
  FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;

    print('FCM Foreground handleMessage ${notification!.title}');
    print('FCM Foreground handleMessage ${notification!.body}');
    print('FCM Foreground handleMessage ${message.data['notificationKey']}');
    print('FCM Foreground handleMessage ${message.data}');
    print('FCM Foreground handleMessage ${message.toString()}');
    print('FCM Foreground handleMessage ${message.data.toString()}');

    if (android != null) {
      flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            channel.id,
            channel.name,
            channelDescription: channel.description,
            icon: android.smallIcon,
          ),
        ),
      );
    }

    // if (message.data['notificationKey'] == 'FORCE_LOGOUT') {
    //   if (Get.currentRoute != Routes.login) {
    //     await showForceLogoutAlert();
    //     forceLogout();
    //   }
    // }
    print('notificationKey : ${message.data['notificationKey']}');
    if (message.data['notificationKey'] == 'DAILY_REWARD_COMPLETED') {
      Get.find<WalletMasterController>().moveToWallet();
      print('DAILY_REWARD_COMPLETED : handleMessage');
      // Get.isRegistered<WalletMasterController>() ? Get.find<WalletMasterController>().moveToWallet() : Get.put(WalletMasterController()).moveToWallet();
    }

    if (message.data['notificationKey'] == 'MY_ITEM') {
      Get.find<HomeMenuController>().selectMenu(1);
    }

    if (message.data['notificationKey'] == 'EXERCISE_RESTRICTION') {
      ActivityController controller = Get.find<ActivityController>();
      controller.handleAlreadyFinishedExercise();
    }

    if (message.data['notificationKey'] == 'CHALLENGE_REWARD_BADGE_ISSUED') {
      PushMessageChallengeSuccessModel data = PushMessageChallengeSuccessModel.fromJson(message.data);
      showChallengeBadgeAcquisitionAlert(data);
    }
  });

  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    handleNotification(message);
  });
}

void handleNotification(RemoteMessage message) {
  if (message.data['notificationKey'] == 'DAILY_REWARD_COMPLETED') {
    HiveStore.save(key: HiveKey.needRouteToGoWallet.name, value: true);
  }

  // if (message.data['notificationKey'] == 'FORCE_LOGOUT') {
  //   HiveStore.save(key: HiveKey.needToForceLogout.name, value: true);
  // }

  if (message.data['notificationKey'] == 'MY_ITEM') {
    Get.find<HomeMenuController>().selectMenu(1);
  }

  if (message.data['notificationKey'] == 'EXERCISE_RESTRICTION') {
    HiveStore.save(key: HiveKey.needToForceStopExercise.name, value: true);
  }

  if (message.data['notificationKey'] == 'CHALLENGE_REWARD_BADGE_ISSUED') {
    PushMessageChallengeSuccessModel data = PushMessageChallengeSuccessModel.fromJson(message.data);
    // showLocalNotification(
    //   notificationType: NotificationType.badge,
    //   title: '챌린지 뱃지 발급!',
    //   message: '${data.challengeTitle} 달성. 새로운 뱃지 확인하러 가자GO~~',
    //   payload: 'NAV-INVENTORY_BADGE',
    // );
    showChallengeBadgeAcquisitionAlert(data);
  }
}

//for iOS and web
Future<void> requestPermission() async {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  await messaging.requestPermission();
}

Future<void> setForegroundConfig() async {
  if (defaultTargetPlatform == TargetPlatform.iOS) {
    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true, // Required to display a heads up notification
      badge: true,
      sound: true,
    );
  }

  const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');

  const DarwinInitializationSettings initializationSettingsIOS = DarwinInitializationSettings(requestAlertPermission: true, requestBadgePermission: true, requestSoundPermission: true);

  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsIOS,
  );

  flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  await flutterLocalNotificationsPlugin.initialize(initializationSettings, onDidReceiveNotificationResponse: onSelectNotification);

  if (defaultTargetPlatform == TargetPlatform.android) {
    await flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.requestPermission();
  } else {
    await flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }
}

void onSelectNotification(NotificationResponse? notificationResponse) {
  if (notificationResponse != null && (notificationResponse.payload == null || notificationResponse.payload != '')) {
    List<String> payload = notificationResponse.payload!.split('-');
    String action = payload[0];
    String route = payload[1];

    if (action == 'NAV') {
      Get.until((route) => route.isFirst);
      switch (route) {
        case 'INVENTORY_BADGE':
          HomeMenuController homeMenuController = Get.isRegistered<HomeMenuController>() ? Get.find<HomeMenuController>() : Get.put(HomeMenuController());
          InventoryHomeController inventoryHomeController = Get.isRegistered<InventoryHomeController>() ? Get.find<InventoryHomeController>() : Get.put(InventoryHomeController());
          homeMenuController.selectMenu(1);
          inventoryHomeController.tabController.animateTo(1);
          break;
        case 'INVENTORY_ITEM':
          HomeMenuController homeMenuController = Get.isRegistered<HomeMenuController>() ? Get.find<HomeMenuController>() : Get.put(HomeMenuController());
          InventoryHomeController inventoryHomeController = Get.isRegistered<InventoryHomeController>() ? Get.find<InventoryHomeController>() : Get.put(InventoryHomeController());
          homeMenuController.selectMenu(1);
          inventoryHomeController.tabController.animateTo(0);
          break;
      }
    }
  }
}

NotificationDetails notificationDetail = NotificationDetails(
  android: AndroidNotificationDetails(
    channel.id,
    channel.name,
    importance: Importance.max,
    priority: Priority.max,
  ),
);

NotificationDetails statLowNotificationDetail = NotificationDetails(
  android: AndroidNotificationDetails(
    '${channel.id}1',
    '${channel.name}1',
    importance: Importance.max,
    priority: Priority.max,
    playSound: true,
    sound: const RawResourceAndroidNotificationSound('stat_low'),
  ),
  iOS: const DarwinNotificationDetails(sound: 'stat_low.mp3'),
);

NotificationDetails statDepletedNotificationDetail = NotificationDetails(
  android: AndroidNotificationDetails(
    '${channel.id}2',
    '${channel.name}2',
    importance: Importance.max,
    priority: Priority.max,
    playSound: true,
    sound: const RawResourceAndroidNotificationSound('stat_depleted'),
  ),
  iOS: const DarwinNotificationDetails(sound: 'stat_depleted.mp3'),
);

NotificationDetails badgeAcquiredNotificationDetail = NotificationDetails(
  android: AndroidNotificationDetails(
    '${channel.id}3',
    '${channel.name}3',
    importance: Importance.max,
    priority: Priority.max,
    playSound: true,
    sound: const RawResourceAndroidNotificationSound('badge_acquired'),
  ),
  iOS: const DarwinNotificationDetails(sound: 'badge_acquired.mp3'),
);

//
// badge,
// stamina,
// durability,

void showLocalNotification({required NotificationType notificationType, required String title, required String message, String? payload, bool allowSeparatePush = false, int separatePushId = -1}) {
  FlutterLocalNotificationsPlugin notificationsPlugin = FlutterLocalNotificationsPlugin();
  NotificationDetails details;
  switch (notificationType) {
    case NotificationType.durabilityLow:
    case NotificationType.staminaLow:
      details = statLowNotificationDetail;
      break;
    case NotificationType.durabilityDepleted:
    case NotificationType.staminaDepleted:
      details = statDepletedNotificationDetail;
      break;
    case NotificationType.badge:
      details = badgeAcquiredNotificationDetail;
      break;
    default:
      details = notificationDetail;
  }
  notificationsPlugin.show(allowSeparatePush ? separatePushId : notificationType.id, title, message, details, payload: payload);
}
