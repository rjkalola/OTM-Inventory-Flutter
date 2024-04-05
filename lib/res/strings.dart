import 'package:get/get_navigation/src/root/internacionalization.dart';

class Strings extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'en_US': {
          'login': 'Login',
          'required_field': 'Required Field',
          'phone': 'Phone',
          'phone_number': 'Phone Number',
          'try_again': "Try Again",
          'no_internet': "Please Check Your Internet Connection!",
          'verify_otp': "Verify Otp",
          'verify_otp_hint1':
              "Enter the four-digit code that you were sent over mobile SMS.",
          'click_on_': "Click On ",
          'resend_': "Resend,",
          'otm_received_note': " if you do not receive after 2 minutes",
          'submit': "Submit",
          'enter_otp': "Enter OTP",
          'otp_resend_success_message': "Otp resend",
          'home': "Home",
          'profile': "Profile",
          'more': "More",
          'product_list': "Product List",
          'empty_data_message': "No data found",
          'sku': "SKU",
          'price': "Price",
          'manufacturer': "Manufacturer",
          'category': "Category",
        },
        'hi_IN': {'login': 'Login'}
      };
}
