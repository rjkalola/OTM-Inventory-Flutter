class AppConstants {
  static const DialogIdentifier dialogIdentifier = DialogIdentifier();
  static const SharedPreferenceKey sharedPreferenceKey = SharedPreferenceKey();
  static const FromScreens fromScreens = FromScreens();
  static const IntentKey intentKey = IntentKey();
  static const Action action = Action();
  static const String deviceType = "1";
}

class IntentKey {
  const IntentKey(); // <
  final String phoneExtension = 'PHONE_EXTENSION';
  final String phoneNumber = 'PHONE_NUMBER';
}

class DialogIdentifier {
  const DialogIdentifier(); // <---
// final String logout = 'logout';
}

class SharedPreferenceKey {
  const SharedPreferenceKey(); // <---
// final String keyLoginData = "KeyLoginData";
}

class Action {
  const Action(); //
// final String clockIn = "ClockIn";
}

class FromScreens {
  const FromScreens(); //
// final String login = "login";
}
