import 'dart:convert';

import 'package:dio/dio.dart' as multi;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/add_category/add_category_repository.dart';
import 'package:otm_inventory/pages/add_category/model/add_category_request.dart';
import 'package:otm_inventory/pages/category_list/model/category_info.dart';
import 'package:otm_inventory/web_services/response/base_response.dart';

import '../../../utils/app_constants.dart';
import '../../../utils/app_utils.dart';
import '../../../web_services/api_constants.dart';
import '../../../web_services/response/response_model.dart';

class AddCategoryController extends GetxController {
  RxBool isLoading = false.obs,
      isInternetNotAvailable = false.obs,
      isMainViewVisible = true.obs,
      isStatus = true.obs,
      isSaveEnable = false.obs;
  RxString title = ''.obs;
  final formKey = GlobalKey<FormState>();
  final _api = AddCategoryRepository();
  final addRequest = AddCategoryRequest();

  final categoryNameController = TextEditingController().obs;

  @override
  void onInit() {
    super.onInit();
    var arguments = Get.arguments;
    if (arguments != null) {
      title.value = 'edit_category'.tr;
      CategoryInfo info = arguments[AppConstants.intentKey.categoryInfo];
      print("info.id:" + info.id.toString());
      print("category name:" + info.name!);

      addRequest.id = info.id ?? 0;
      categoryNameController.value.text = info.name ?? "";
      isStatus.value = info.status ?? false;
    } else {
      title.value = 'add_category'.tr;
    }
  }

  void onSubmitClick() {
    if (formKey.currentState!.validate()) {
      if (isSaveEnable.value) {
        addRequest.category_name =
            categoryNameController.value.text.toString().trim();
        addRequest.status = isStatus.value;
        storeCategoryApi();
      } else {
        Get.back();
      }
    }
  }

  void storeCategoryApi() async {
    Map<String, dynamic> map = {};
    map["id"] = addRequest.id;
    map["category_name"] = addRequest.category_name;
    // map["status"] = addRequest.status;
    map["status"] = true;
    multi.FormData formData = multi.FormData.fromMap(map);

    print("Request Data:" + map.toString());

    isLoading.value = true;

    _api.storeCategory(
      formData: formData,
      onSuccess: (ResponseModel responseModel) {
        isLoading.value = false;
        if (responseModel.statusCode == 200) {
          BaseResponse response =
              BaseResponse.fromJson(jsonDecode(responseModel.result!));
          if (response.IsSuccess!) {
            Get.back(result: true);
          } else {
            AppUtils.showSnackBarMessage(response.Message!);
          }
        } else {
          AppUtils.showSnackBarMessage(responseModel.statusMessage!);
        }
      },
      onError: (ResponseModel error) {
        isLoading.value = false;
        if (error.statusCode == ApiConstants.CODE_NO_INTERNET_CONNECTION) {
          AppUtils.showSnackBarMessage('no_internet'.tr);
        } else if (error.statusMessage!.isNotEmpty) {
          AppUtils.showSnackBarMessage(error.statusMessage!);
        }
      },
    );
  }

  void onValueChange() {
    isSaveEnable.value = true;
  }
}
