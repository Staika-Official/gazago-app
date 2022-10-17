import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart' show defaultTargetPlatform, TargetPlatform;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:gaza_go/constants/enums.dart';
import 'package:gaza_go/platform/stores/hive_store.dart';
import 'package:logger/logger.dart';

late AndroidNotificationChannel channel;
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
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;

    print('FCM Foreground handleMessage ${notification!.title}');

    if (notification != null && android != null) {
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
  });
}

//for iOS and web
Future<void> requestPermission() async {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  NotificationSettings settings = await messaging.requestPermission();
}

Future<void> setForegroundConfig() async {
  if (defaultTargetPlatform == TargetPlatform.iOS) {
    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true, // Required to display a heads up notification
      badge: true,
      sound: true,
    );
  } else if (defaultTargetPlatform == TargetPlatform.android) {
    channel = const AndroidNotificationChannel(
      'high_importance_channel',
      'High Importance Notifications',
      description: 'This channel is used for important notifications.',
      importance: Importance.max,
    );
  }

  const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');

  const IOSInitializationSettings initializationSettingsIOS = IOSInitializationSettings(requestAlertPermission: true, requestBadgePermission: true, requestSoundPermission: true);

  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsIOS,
  );

  flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  if (defaultTargetPlatform == TargetPlatform.android) {
    await flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.requestPermission();
    await flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.createNotificationChannel(channel);
  }
}
