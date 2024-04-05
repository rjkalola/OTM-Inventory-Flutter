import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/login/login_repository.dart';
import 'package:otm_inventory/pages/login/models/RegisterResourcesResponse.dart';
import 'package:otm_inventory/utils/app_utils.dart';
import 'package:otm_inventory/web_services/api_constants.dart';
import 'package:otm_inventory/web_services/response/status.dart';

import '../../web_services/response/response_model.dart';

class LoginController extends GetxController {
  final phoneController = TextEditingController().obs;
  final mExtension = "+91".obs;
  final mFlag = "https://cdn.otmsystem.com//flags//png//in_32.png".obs;

  final _api = LoginRepository();
  final rxRequestStatus = Status.LOADING.obs;
  final registerResourcesResponse = RegisterResourcesResponse().obs;
  RxString error = ''.obs;
  RxBool isLoading = false.obs, isInternetNotAvailable = false.obs;

  @override
  void onInit() {
    super.onInit();
    getRegisterResources();
  }

  void getRegisterResources() {
    _api.getRegisterResources(
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.statusCode == 200) {
          if (responseModel.result!.isNotEmpty) {
            setRegisterResourcesResponse(RegisterResourcesResponse.fromJson(
                jsonDecode(responseModel.result!)));
          }
        } else {
          AppUtils.showSnackBarMessage(responseModel.statusMessage!);
        }
        isLoading.value = false;
        // update();
      },
      onError: (ResponseModel error) {
        isLoading.value = false;
        if (error.statusCode == ApiConstants.CODE_NO_INTERNET_CONNECTION) {
          isInternetNotAvailable.value = true;
          AppUtils.showSnackBarMessage('no_internet'.tr);
        } else if (error.statusMessage!.isNotEmpty) {
          AppUtils.showSnackBarMessage(error.statusMessage!);
        }
        // update();
      },
    );
    // _api.getRegisterResources().then((value) {
    //   if (value != null) {
    //     if (kDebugMode) {
    //       print("Response:$value");
    //     }
    //     setRxRequestStatus(Status.COMPLETED);
    //     setUserList(RegisterResourcesResponse.fromJson(value));
    //   }
    // }).onError((error, stackTrace) {
    //   print("error:" + error.toString());
    //   setError(error.toString());
    //   setRxRequestStatus(Status.ERROR);
    // });
  }

  void setRxRequestStatus(Status value) => rxRequestStatus.value = value;

  void setRegisterResourcesResponse(RegisterResourcesResponse value) =>
      registerResourcesResponse.value = value;

  void setError(String value) => error.value = value;
}
