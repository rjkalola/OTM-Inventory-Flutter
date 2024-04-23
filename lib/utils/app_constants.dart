class AppConstants {
  static const DialogIdentifier dialogIdentifier = DialogIdentifier();
  static const SharedPreferenceKey sharedPreferenceKey = SharedPreferenceKey();
  static const FromScreens fromScreens = FromScreens();
  static const IntentKey intentKey = IntentKey();
  static const Action action = Action();
  static const String deviceType = "1";
  static const int productListLimit = 20;
}

class IntentKey {
  const IntentKey(); // <
  final String phoneExtension = 'PHONE_EXTENSION';
  final String phoneNumber = 'PHONE_NUMBER';
  final String productInfo = 'PRODUCT_INFO';
  final String storeInfo = 'STORE_INFO';
  final String supplierInfo = 'SUPPLIER_INFO';
  final String categoryInfo = 'CATEGORY_INFO';
  final String stockInfo = 'STOCK_INFO';
  final String productId = 'PRODUCT_ID';
  final String storeId = 'STORE_ID';
}

class DialogIdentifier {
  const DialogIdentifier(); // <---
  final String logout = 'logout';
  final String categoryList = 'CATEGORY_LIST';
  final String supplierList = 'SUPPLIER_LIST';
  final String lengthUnitList = 'LENGTH_UNIT_LIST';
  final String weightUnitList = 'WEIGHT_UNIT_LIST';
  final String manufacturerList = 'MANUFACTURER_LIST';
  final String modelList = 'MODEL_LIST';
  final String usersList = 'USERS_LIST';
  final String storeList = 'STORE_LIST';
}

class SharedPreferenceKey {
  const SharedPreferenceKey(); // <---
  final String userInfo = "USER_INFO";
  final String accessToken = "ACCESS_TOKEN";
  final String storeId = "STORE_ID";
  final String storeName = "STORE_NAME";
}

class Action {
  const Action(); //
  final String items = "ITEMS";
  final String store = "STORE";
  final String suppliers = "SUPPLIERS";
  final String categories = "CATEGORIES";
  final String stocks = "STOCKS";
}

class FromScreens {
  const FromScreens(); //
// final String login = "login";
}
