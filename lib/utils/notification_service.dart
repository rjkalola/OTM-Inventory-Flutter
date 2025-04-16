import 'dart:convert';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/routes/app_routes.dart';
import 'package:permission_handler/permission_handler.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    await _requestPermissions();

    const androidSettings =
        AndroidInitializationSettings('@drawable/ic_stat_notification');
    const initSettings = InitializationSettings(android: androidSettings);

    await _localNotifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        if (response.payload != null) {
          final Map<String, dynamic> data = jsonDecode(response.payload!);
          String rout = AppRoutes.splashScreen;
          final notificationType = data['notification_type'] ?? "";
          print("notificationType:" + notificationType);

          if (notificationType == "9251" || notificationType == "9251") {
            rout = AppRoutes.orderListScreen;
            Get.offNamed(rout);
          }
        }
      },
    );
  }

  static Future<void> _requestPermissions() async {
    // Android 13+
    if (await Permission.notification.isDenied) {
      final status = await Permission.notification.request();
      if (!status.isGranted) {
        print('🔒 Android permission denied');
        return;
      }
    }

    // iOS
    final settings = await FirebaseMessaging.instance.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.denied) {
      print('🔒 iOS notification permission denied');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.notDetermined) {
      print('🕒 iOS notification permission not determined');
    } else {
      print('✅ Notification permission granted');
    }
  }

  static void showForegroundNotification(RemoteMessage message) {
    final notification = message.notification;
    final android = notification?.android;

    if (notification != null && android != null) {
      _localNotifications.show(
          notification.hashCode,
          notification.title,
          notification.body,
          const NotificationDetails(
            android: AndroidNotificationDetails(
              'high_importance_channel',
              'High Importance Notifications',
              icon: 'ic_stat_notification', // <-- no file extension
              importance: Importance.max,
              priority: Priority.high,
              showWhen: true,
            ),
          ),
          payload: jsonEncode(message.data));
    }
  }

  static void handleMessageNavigation(RemoteMessage message) {
    final data = message.data;
    // final feedType = data['feed_type'] ?? ""; //
    final notificationType = data['notification_type'] ?? "";
    print("notificationType:" + notificationType);

    if (notificationType == "9251" || notificationType == "9251") {
      Get.offNamed(AppRoutes.orderListScreen);
    }
  }

  static String getInitialRout(Map<String, dynamic> data) {
    String rout = AppRoutes.splashScreen;
    // final feedType = data['feed_type'] ?? ""; //
    // print("feedType:" + feedType);
    final notificationType = data['notification_type'] ?? "";
    print("notificationType:" + notificationType);

    if (notificationType == "9251" || notificationType == "9251") {
      rout = AppRoutes.orderListScreen;
    }
    return rout;
  }
}
