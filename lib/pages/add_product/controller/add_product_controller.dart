import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class AddProductController extends GetxController {
  RxBool isLoading = false.obs, isInternetNotAvailable = false.obs;
  final formKey = GlobalKey<FormState>();

  final productTitleController = TextEditingController().obs;

  void onSubmitClick(){

  }
}
