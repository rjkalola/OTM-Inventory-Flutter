import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/res/colors.dart';
import 'package:otm_inventory/res/strings.dart';
import 'package:otm_inventory/routes/app_pages.dart';
import 'package:otm_inventory/routes/app_routes.dart';
import 'package:otm_inventory/utils/app_storage.dart';
import 'package:otm_inventory/utils/notification_service.dart';
import 'package:otm_inventory/web_services/api_constants.dart';

// Local notifications plugin instance
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

RemoteMessage? _initialMessage;

void main() async {
  await Get.put(AppStorage()).initStorage();

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await NotificationService.init();

  // await requestNotificationPermission();

  _initialMessage = await FirebaseMessaging.instance.getInitialMessage();

  // await initializeLocalNotifications();

  runApp(MyApp());
}

Future<void> initializeLocalNotifications() async {
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  const InitializationSettings initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid);

  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onDidReceiveNotificationResponse: (NotificationResponse response) {
      if (response.payload != null) {
        final Map<String, dynamic> data = jsonDecode(response.payload!);
        String rout = AppRoutes.splashScreen;
        final feedType = data['feed_type'] ?? ""; //
        if (feedType == "111") {
          rout = AppRoutes.orderListScreen;
          Get.offNamed(rout);
        }
      }
    },
  );
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();
    ApiConstants.accessToken = Get.find<AppStorage>().getAccessToken();
    AppStorage.storeId = Get.find<AppStorage>().getStoreId();
    AppStorage.storeName = Get.find<AppStorage>().getStoreName();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    String initialRoute = AppRoutes.splashScreen;
    if (_initialMessage != null) {
      initialRoute = NotificationService.getInitialRout(_initialMessage!.data);
      print("initialRoute:" + initialRoute);
    }
    _setupFCM();

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: initialRoute,
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
    // await requestNotificationPermission();

    // Tapping notification (background)
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      NotificationService.handleMessageNavigation(message);
      // _handleMessageNavigation(message);
    });

    // Foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      NotificationService.showForegroundNotification(message);
      // RemoteNotification? notification = message.notification;
      // AndroidNotification? android = message.notification?.android;
      //
      // if (notification != null && android != null) {
      //   flutterLocalNotificationsPlugin.show(
      //       notification.hashCode,
      //       notification.title,
      //       notification.body,
      //       const NotificationDetails(
      //         android: AndroidNotificationDetails(
      //           'high_importance_channel',
      //           'High Importance Notifications',
      //           icon: 'ic_stat_notification', // <-- no file extension
      //           importance: Importance.max,
      //           priority: Priority.high,
      //           showWhen: true,
      //         ),
      //       ),
      //       payload: jsonEncode(message.data));
      // }
    });
  }

  void _handleMessageNavigation(RemoteMessage message) {
    final data = message.data;
    final feedType = data['feed_type'] ?? ""; //

    if (feedType == "111") {
      print("feedType == 111");
      Get.offNamed(AppRoutes.orderListScreen);
    }

    // You can add conditions for other screens too
  }

// String getInitialRout(Map<String, dynamic> data) {
//   String rout = AppRoutes.splashScreen;
//   final feedType = data['feed_type'] ?? ""; //
//   print("feedType:" + feedType);
//   if (feedType == "111") {
//     rout = AppRoutes.orderListScreen;
//   }
//   return rout;
// }
}

Future<void> requestNotificationPermission() async {
  NotificationSettings settings =
      await FirebaseMessaging.instance.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    print('🔔 Notification permission granted.');
  } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
    print('🕒 Provisional notification permission granted.');
  } else {
    print('❌ Notification permission denied.');
  }
}
