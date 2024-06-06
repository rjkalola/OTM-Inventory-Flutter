class AppConstants {
  static const DialogIdentifier dialogIdentifier = DialogIdentifier();
  static const SharedPreferenceKey sharedPreferenceKey = SharedPreferenceKey();
  static const FromScreens fromScreens = FromScreens();
  static const IntentKey intentKey = IntentKey();
  static const Action action = Action();
  static const StockFilterType stockFilterType = StockFilterType();
  static const String deviceType = "1";
  static const int productListLimit = 20;
  static const int defaultPhoneExtensionId = 1;
  static const String defaultPhoneExtension = "+44";
  static const String defaultFlagUrl =
      "https://devcdn.otmsystem.com/flags/png/gb_32.png";
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
  final String dashboardTabIndex = 'DASHBOARD_TAB_INDEX';
  final String barCode = 'BAR_CODE';
}

class DialogIdentifier {
  const DialogIdentifier(); // <---
  final String logout = 'logout';
  final String categoryList = 'CATEGORY_LIST';
  final String supplierList = 'SUPPLIER_LIST';
  final String lengthUnitList = 'LENGTH_UNIT_LIST';
  final String weightUnitList = 'WEIGHT_UNIT_LIST';
  final String manufacturerList = 'MANUFACTURER_LIST';
  final String attachmentOptionsList = 'ATTACHMENT_OPTIONS_LIST';
  final String modelList = 'MODEL_LIST';
  final String usersList = 'USERS_LIST';
  final String storeList = 'STORE_LIST';
  final String stockOptionsDialog = 'stockOptionsDialog';
  final String attachBarcodeDialog = 'attachBarcodeDialog';
  final String updateBarcodeDialog = 'updateBarcodeDialog';
  final String deleteProduct = 'DELETE_PRODUCT';
  final String deleteStock = 'DELETE_STOCK';
  final String selectDate = 'SELECT_DATE';
  final String deleteProductImage = 'DELETE_PRODUCT_IMAGE';
  final String quantityNote = 'QUANTITY_NOTE';
}

class SharedPreferenceKey {
  const SharedPreferenceKey(); // <---
  final String userInfo = "USER_INFO";
  final String accessToken = "ACCESS_TOKEN";
  final String storeId = "STORE_ID";
  final String storeName = "STORE_NAME";
  final String savedLoginUserList = "SAVED_LOGIN_USER_LIST";
  final String quantityNote = "QUANTITY_NOTE";
  final String stockList = "STOCK_LIST";
  final String productList = "PRODUCT_LIST";
  final String stockResources = "STOCK_RESOURCES";
  final String productResources = "PRODUCT_RESOURCES";
  final String localStoredStockList = "LOCAL_STORED_STOCk_LIST";
  final String dashboardItemCountData = "DASHBOARD_ITEM_COUNT_DATA";
  final String localStoredProductList = "LOCAL_STORED_PRODUCT_LIST";
  final String stockSize = "STOCK_SIZE";
}

class Action {
  const Action(); //
  final String items = "ITEMS";
  final String store = "STORE";
  final String suppliers = "SUPPLIERS";
  final String categories = "CATEGORIES";
  final String stocks = "STOCKS";
  final String vendors = "VENDORS";
  final String manufacturer = "MANUFACTURER";
  final String selectImageFromCamera = 'SELECT_IMAGE_FROM_CAMERA';
  final String selectImageFromGallery = 'SELECT_IMAGE_FROM_GALLERY';
}

class FromScreens {
  const FromScreens(); //
// final String login = "login";
}

class StockFilterType {
  const StockFilterType(); //
  final String filterAll = "FILTER_ALL";
  final String filterIn = "FILTER_IN";
  final String filterOut = "FILTER_OUT";
}
