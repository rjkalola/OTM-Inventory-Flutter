import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/routes/app_routes.dart';
import 'package:otm_inventory/utils/notification_service.dart';
import 'package:otm_inventory/utils/string_helper.dart';
import 'package:otm_inventory/web_services/api_constants.dart';

import '../../utils/app_constants.dart';
import '../../utils/app_storage.dart';

class SplashServices {
  void isLogin() {
    AppStorage().removeData(AppConstants.sharedPreferenceKey.quantityNote);
    ApiConstants.accessToken = Get.find<AppStorage>().getAccessToken();
    initializeApp();
  }

  Future<void> initializeApp() async {
    // Handle initial notification (cold start)
    if (!StringHelper.isEmptyString(ApiConstants.accessToken)) {
      RemoteMessage? message =
          await FirebaseMessaging.instance.getInitialMessage();
      if (message != null) {
        NotificationService.notificationClick(message.data);
        // _handleNotificationNavigation(message);
        return;
      }

      // Tapping notification (background)
      FirebaseMessaging.onMessageOpenedApp.listen((message) {
        // NotificationService.handleMessageNavigation(message);
        NotificationService.notificationClick(message.data);
        // _handleMessageNavigation(message);
      });

      // Foreground messages
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        NotificationService.showForegroundNotification(message);
      });
    }

    Timer(const Duration(seconds: 1), () async {
      if (!StringHelper.isEmptyString(ApiConstants.accessToken)) {
        Get.offAllNamed(AppRoutes.dashboardScreen);
      } else {
        Get.offAllNamed(AppRoutes.loginScreen);
      }
    });
  }
}
