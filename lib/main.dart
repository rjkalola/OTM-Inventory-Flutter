import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/common/controller/common_repository.dart';
import 'package:otm_inventory/res/colors.dart';
import 'package:otm_inventory/res/strings.dart';
import 'package:otm_inventory/routes/app_pages.dart';
import 'package:otm_inventory/utils/app_constants.dart';
import 'package:otm_inventory/utils/app_storage.dart';
import 'package:otm_inventory/utils/app_utils.dart';
import 'package:otm_inventory/utils/string_helper.dart';
import 'package:otm_inventory/web_services/api_constants.dart';
import 'package:dio/dio.dart' as multi;
import 'package:otm_inventory/web_services/response/base_response.dart';
import 'package:otm_inventory/web_services/response/response_model.dart';

// Local notifications plugin instance
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

// Background message handler
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('🔕 BG Message: ${message.messageId}');
}

void main() async {
  await Get.put(AppStorage()).initStorage();

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  await initializeLocalNotifications();

  runApp(MyApp());
}

Future<void> initializeLocalNotifications() async {
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  const InitializationSettings initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid);

  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    // onDidReceiveNotificationResponse: (NotificationResponse response) {
    //   print("onDidReceiveNotificationResponse:");
    //   final String? payload = response.payload;
    //   if (payload != null) {
    //     final Map<String, dynamic> data = jsonDecode(payload);
    //     final feedType = data['feed_type'] ?? ""; //
    //     print("payload feedType:" + feedType ?? "");
    //     final title = data['title'] ?? ""; //
    //     print("payload title:" + title ?? "");
    //     final body = data['body'] ?? ""; //// e.g., 'feed'
    //     print("payload body:" + body ?? "");
    //
    //     // final route = data['route'];
    //     // final bundle =
    //     //     data['bundle'] != null ? jsonDecode(data['bundle']) : null;
    //     //
    //     // Get.toNamed(route, arguments: {
    //     //   'orderId': data['orderId'],
    //     //   'status': data['status'],
    //     //   'bundle': bundle,
    //     // });
    //   }
    // },
  );
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _token = '';
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();
    ApiConstants.accessToken = Get.find<AppStorage>().getAccessToken();
    AppStorage.storeId = Get.find<AppStorage>().getStoreId();
    AppStorage.storeName = Get.find<AppStorage>().getStoreName();
    _setupFCM();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'app_title'.tr,
      translations: Strings(),
      locale: const Locale('en', 'us'),
      getPages: AppPages.list,
      theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: defaultAccentColor),
          useMaterial3: true,
          dialogBackgroundColor: Colors.white),
      // home: const SplashScreen(),
      navigatorKey: navigatorKey,
    );
  }

  void _setupFCM() async {
    await requestNotificationPermission();

    // Foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.data != null) {
        print('📥 Foreground message data: ${message.data}');
      }
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;

      // _handleMessageNavigation(message);

      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              'high_importance_channel',
              'High Importance Notifications',
              icon: 'ic_stat_notification', // <-- no file extension
              importance: Importance.max,
              priority: Priority.high,
              showWhen: true,
            ),
          ),
        );
      }
    });

    // Tapping notification (terminated)
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        _handleMessageNavigation(message);
        print('🔔 App launched from terminated due to notification');
      }
    });

    // Tapping notification (background)
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      _handleMessageNavigation(message);
      print('🔔 App opened from background by tapping notification');
    });
  }

  void _handleMessageNavigation(RemoteMessage message) {
    final data = message.data;
    final feedType = data['feed_type'] ?? ""; //
    print("feedType:" + feedType ?? "");
    final title = data['title'] ?? ""; //
    print("title:" + title ?? "");
    final body = data['body'] ?? ""; //// e.g., 'feed'
    print("body:" + body ?? "");

    if (feedType == "111") {
      print("feedType == 111");
      Get.toNamed('/order_list_screen');
    } else {
      print("feedType != 111");
    }

    // You can add conditions for other screens too
  }

  Future<void> requestNotificationPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      criticalAlert: true,
    );

    print('🔒 Permission granted: ${settings.authorizationStatus}');
  }
}
