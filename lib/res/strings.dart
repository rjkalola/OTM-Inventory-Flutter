import 'package:get/get_navigation/src/root/internacionalization.dart';

class Strings extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'en_US': {
          'login': 'Login',
          'required_field': 'Required Field',
          'phone': 'Phone',
          'phone_number': 'Phone Number',
          "try_again": "Try Again",
          "no_internet": "Please Check Your Internet Connection!",
        },
        'hi_IN': {'login': 'Login'}
      };
}
