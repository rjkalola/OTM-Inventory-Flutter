
class ApiConstants {
  static String appUrl = "https://dev.otmsystem.com/api/v1";
  static String accessToken = "";
  static const CODE_NO_INTERNET_CONNECTION = 10000;

  static Map<String, String> getHeader() {
    return {
      "Content-Type": "application/json",
      "Authorization": "Bearer $accessToken",
    };
  }

  static String registerResourcesUrl = '$appUrl/wn-resources';
  static String verifyPhoneUrl = '$appUrl/verify-phone';
  static String loginUrl = '$appUrl/login-new';
  static String getProductsUrl = '$appUrl/products/get';
  static String getProductResourcesUrl = '$appUrl/products/get-resources';
  static String storeProductUrl = '$appUrl/products/store';
  static String getProductDetailsUrl = '$appUrl/products/edit-product';
  static String getStoreListUrl = '$appUrl/stores/get';
  static String getSupplierListUrl = '$appUrl/suppliers/get';
  static String getStoreResourcesUrl = '$appUrl/stores/get-resources';
  static String storeStoreUrl = '$appUrl/stores/store';
}
