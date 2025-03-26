class AppConstants {
  static const DialogIdentifier dialogIdentifier = DialogIdentifier();
  static const SharedPreferenceKey sharedPreferenceKey = SharedPreferenceKey();
  static const FromScreens fromScreens = FromScreens();
  static const IntentKey intentKey = IntentKey();
  static const Action action = Action();
  static const StockFilterType stockFilterType = StockFilterType();
  static const StockCountType stockCountType = StockCountType();
  static const PurchaseOrderStatus purchaseOrderStatus = PurchaseOrderStatus();
  static const OrderStatus orderStatus = OrderStatus();

  static const String deviceType = "1";
  static const int productListLimit = 20;
  static const int defaultPhoneExtensionId = 1;
  static const String defaultPhoneExtension = "+44";
  static const String defaultFlagUrl =
      "https://devcdn.otmsystem.com/flags/png/gb_32.png";
  static bool isResourcesLoaded = false;
}

class IntentKey {
  const IntentKey(); // <
  final String phoneExtension = 'PHONE_EXTENSION';
  final String phoneNumber = 'PHONE_NUMBER';
  final String productInfo = 'PRODUCT_INFO';
  final String orderInfo = 'ORDER_INFO';
  final String mId = 'ID';
  final String storeInfo = 'STORE_INFO';
  final String supplierInfo = 'SUPPLIER_INFO';
  final String categoryInfo = 'CATEGORY_INFO';
  final String stockInfo = 'STOCK_INFO';
  final String productId = 'PRODUCT_ID';
  final String localProductId = 'LOCAL_PRODUCT_ID';
  final String storeId = 'STORE_ID';
  final String dashboardTabIndex = 'DASHBOARD_TAB_INDEX';
  final String barCode = 'BAR_CODE';
  final String stockCountType = 'STOCK_COUNT_TYPE';
  final String allStockType = 'ALL_STOCK_TYPE';
  final String pdfUrl = 'PDF_URL';
  final String purchaseOrderInfo = 'PURCHASE_ORDER_INFO';
  final String title = 'TITLE';
  final String count = 'COUNT';
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
  final String deleteBarcode = 'DELETE_BARCODE';
  final String addProductOptionsDialog = 'addProductOptionsDialog';
  final String orderStatusChangeDialog = 'ORDER_STATUS_CHANGE_DIALOG';
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
  final String stockSize = "STOCK_SIZE";
  final String tempIds = "TEMP_IDS";
  final String stockFilterData = "STOCK_FILTER_DATA";
  final String lastUpdateTime = "LAST_UPDATE_TIME";
  final String editStockUserName = "EDIT_STOCK_USER_NAME";
  final String editStockUserId = "EDIT_STOCK_USER_ID";
  final String permissionSettings = "PERMISSION_SETTINGS";
  final String purchaseOrderList = "PURCHASE_ORDER_LIST";
  final String localReceivedPurchaseOrderList =
      "LOCAL_RECEIVED_PURCHASE_ORDER_LIST";
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
  final String a4Print = "A4Print";
  final String a4WithPicturesPrint = "A4WithPicturesPrint";
  final String mobilePrint = "MobilePrint";
  final String viewPdf = "VIEW_PDF";
  final String downloadPdf = "DOWNLOAD_PDF";
  final String importProducts = "IMPORT_PRODUCTS";
  final String addProductManually = "ADD_PRODUCT_MANUALLY";
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

class StockCountType {
  const StockCountType(); //
  final int inStock = 1;
  final int lowStock = 2;
  final int outOfStock = 3;
  final int minusStock = 4;
  final int finishingStock = 5;
}

class PurchaseOrderStatus {
  const PurchaseOrderStatus(); //
  final int ISSUED = 0;
  final int PARTIALLY_RECEIVED = 1;
  final int RECEIVED = 2;
  final int UNLOCKED = 3;
  final int CANCELLED = 4;
}

class OrderStatus {
  const OrderStatus(); //
  final int PLACED = 1;
  final int ACCEPTED = 2;
  final int REJECTED = 3;
  final int IN_PROGRESS = 4;
  final int READY_TO_DELIVERED = 5;
  final int RECEIVED = 6;
  final int DELIVERED = 7;
  final int CANCELLED = 8;
  final int RETURNED = 9;
}
