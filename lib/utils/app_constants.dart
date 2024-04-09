class AppConstants {
  static const DialogIdentifier dialogIdentifier = DialogIdentifier();
  static const SharedPreferenceKey sharedPreferenceKey = SharedPreferenceKey();
  static const FromScreens fromScreens = FromScreens();
  static const IntentKey intentKey = IntentKey();
  static const Action action = Action();
  static const String deviceType = "1";
  static const int productListLimit = 10;
}

class IntentKey {
  const IntentKey(); // <
  final String phoneExtension = 'PHONE_EXTENSION';
  final String phoneNumber = 'PHONE_NUMBER';
}

class DialogIdentifier {
  const DialogIdentifier(); // <---
final String logout = 'logout';
}

class SharedPreferenceKey {
  const SharedPreferenceKey(); // <---
  final String userInfo = "USER_INFO";
  final String accessToken = "ACCESS_TOKEN";
}

class Action {
  const Action(); //
  final String items = "ITEMS";
  final String store = "STORE";
  final String vendors = "VENDORS";
}

class FromScreens {
  const FromScreens(); //
// final String login = "login";
}
