
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
}
