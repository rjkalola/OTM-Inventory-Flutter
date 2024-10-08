import 'dart:convert';
import 'package:dio/dio.dart' as multi;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/add_store/model/store_resources_response.dart';
import 'package:otm_inventory/pages/common/listener/select_multi_item_listener.dart';
import 'package:otm_inventory/utils/string_helper.dart';
import 'package:otm_inventory/web_services/response/base_response.dart';
import 'package:otm_inventory/web_services/response/module_info.dart';

import '../../../utils/app_constants.dart';
import '../../../utils/app_utils.dart';
import '../../../web_services/api_constants.dart';
import '../../../web_services/response/response_model.dart';
import '../../common/drop_down_multi_selection_list_dialog.dart';
import '../../common/listener/SelectPhoneExtensionListener.dart';
import '../../common/phone_extension_list_dialog.dart';
import '../../store_list/model/store_info.dart';
import '../model/add_store_request.dart';
import 'add_store_repository.dart';

class AddStoreController extends GetxController
    implements SelectMultiItemListener, SelectPhoneExtensionListener {
  RxBool isLoading = false.obs,
      isInternetNotAvailable = false.obs,
      isMainViewVisible = false.obs,
      isStatus = true.obs,
      isSaveEnable = false.obs;
  RxString title = ''.obs;
  final mExtension = "".obs;
  final mFlag = "".obs;
  final formKey = GlobalKey<FormState>();
  final _api = AddStoreRepository();
  final resourcesResponse = StoreResourcesResponse().obs;
  final addRequest = AddStoreRequest();

  final storeNameController = TextEditingController().obs;
  final phoneExtensionController = TextEditingController().obs;
  final phoneNumberController = TextEditingController().obs;
  final addressController = TextEditingController().obs;
  final storeManagerController = TextEditingController().obs;
  final emailController = TextEditingController().obs;
  final streetController = TextEditingController().obs;
  final townController = TextEditingController().obs;
  final postcodeController = TextEditingController().obs;

  @override
  void onInit() {
    super.onInit();
    var arguments = Get.arguments;
    if (arguments != null) {
      title.value = 'edit_store'.tr;
      StoreInfo info = arguments[AppConstants.intentKey.storeInfo];
      print("info.id:" + info.id.toString());
      print("store name:" + info.storeName!);

      addRequest.id = info.id ?? 0;
      addRequest.store_name = info.storeName ?? "";
      addRequest.phone_extension_id =
          info.phoneExtensionId ?? AppConstants.defaultPhoneExtensionId;
      addRequest.phone_extension =
          info.phoneExtensionName ?? AppConstants.defaultPhoneExtension;
      addRequest.phone = info.phone ?? "";
      addRequest.address = info.address ?? "";
      addRequest.location = info.location ?? "";
      addRequest.street = info.street ?? "";
      addRequest.town = info.town ?? "";
      addRequest.postcode = info.postcode ?? "";
      addRequest.email = info.email ?? "";

      storeNameController.value.text = info.storeName ?? "";
      mExtension.value =
          info.phoneExtensionName ?? AppConstants.defaultPhoneExtension;
      mFlag.value = info.flagName ?? AppConstants.defaultFlagUrl;

      phoneExtensionController.value.text =
          info.phoneExtensionName ?? AppConstants.defaultPhoneExtension;
      phoneNumberController.value.text = info.phone ?? "";
      addressController.value.text = info.location ?? "";
      streetController.value.text = info.street ?? "";
      townController.value.text = info.town ?? "";
      postcodeController.value.text = info.postcode ?? "";
      emailController.value.text = info.email ?? "";

      if (info.user != null && info.user!.isNotEmpty) {
        addRequest.store_managers =
            StringHelper.getCommaSeparatedIds(info.user!);
        storeManagerController.value.text =
            StringHelper.getCommaSeparatedNames(info.user!);
      }

      isStatus.value = info.status ?? false;
    } else {
      title.value = 'add_store'.tr;

      mExtension.value = AppConstants.defaultPhoneExtension;
      mFlag.value = AppConstants.defaultFlagUrl;

      addRequest.phone_extension_id = AppConstants.defaultPhoneExtensionId;
      addRequest.phone_extension = AppConstants.defaultPhoneExtension;
    }
    getStoreResourcesApi();
  }

  void onSubmitClick() {
    if (formKey.currentState!.validate()) {
      if (isSaveEnable.value) {
        addRequest.store_name =
            storeNameController.value.text.toString().trim();
        addRequest.phone = phoneNumberController.value.text.toString().trim();
        addRequest.email = emailController.value.text.toString().trim();
        addRequest.address = addressController.value.text.toString().trim();
        addRequest.location = addressController.value.text.toString().trim();
        addRequest.street = streetController.value.text.toString().trim();
        addRequest.town = townController.value.text.toString().trim();
        addRequest.postcode = postcodeController.value.text.toString().trim();

        if (addRequest.id != null && addRequest.id != 0) {
          addRequest.mode_type = 2;
        } else {
          addRequest.mode_type = 1;
        }

        addRequest.status = isStatus.value;

        storeStoreApi();
      } else {
        Get.back();
      }
    }
  }

  void showStoreManagerList() {
    if (resourcesResponse.value.users != null &&
        resourcesResponse.value.users!.isNotEmpty) {
      List<ModuleInfo> listUsers = [];
      for (int i = 0; i < resourcesResponse.value.users!.length; i++) {
        ModuleInfo info = ModuleInfo();
        info.id = resourcesResponse.value.users![i].id;
        info.name = resourcesResponse.value.users![i].name;
        info.check = resourcesResponse.value.users![i].check;
        listUsers.add(info);
      }

      showDropDownDialog(AppConstants.dialogIdentifier.usersList,
          'store_manager'.tr, listUsers, this);
    }
  }

  void showDropDownDialog(String dialogType, String title,
      List<ModuleInfo> list, SelectMultiItemListener listener) {
    Get.bottomSheet(
        DropDownMultiSelectionListDialog(
            title: title,
            dialogType: dialogType,
            list: list,
            listener: listener),
        backgroundColor: Colors.transparent,
        isScrollControlled: true);
  }

  @override
  void onSelectMultiItem(List<ModuleInfo> tempList, String action) {
    if (action == AppConstants.dialogIdentifier.usersList) {
      onValueChange();
      resourcesResponse.value.users!.clear();
      resourcesResponse.value.users!.addAll(tempList);

      List<ModuleInfo> listSelectedItems = [];
      for (int i = 0; i < tempList.length; i++) {
        if (tempList[i].check ?? false) {
          listSelectedItems.add(tempList[i]);
        }
      }

      storeManagerController.value.text =
          StringHelper.getCommaSeparatedNames(listSelectedItems);
      addRequest.store_managers =
          StringHelper.getCommaSeparatedIds(listSelectedItems);
    }
  }

  void showPhoneExtensionDialog() {
    Get.bottomSheet(
        PhoneExtensionListDialog(
            title: 'select_phone_extension'.tr,
            list: resourcesResponse.value.countries!,
            listener: this),
        backgroundColor: Colors.transparent,
        isScrollControlled: true);
  }

  @override
  void onSelectPhoneExtension(
      int id, String extension, String flag, String country) {
    onValueChange();
    mFlag.value = flag;
    mExtension.value = extension;
    addRequest.phone_extension_id = id;
    addRequest.phone_extension = extension;
  }

  void getStoreResourcesApi() async {
    Map<String, dynamic> map = {};
    multi.FormData formData = multi.FormData.fromMap(map);
    isLoading.value = true;

    _api.getStoreResources(
      formData: formData,
      onSuccess: (ResponseModel responseModel) {
        isLoading.value = false;
        if (responseModel.statusCode == 200) {
          StoreResourcesResponse response = StoreResourcesResponse.fromJson(
              jsonDecode(responseModel.result!));
          if (response.IsSuccess!) {
            resourcesResponse.value = response;
            isMainViewVisible.value = true;
            if (!StringHelper.isEmptyString(addRequest.store_managers)) {
              List<String> listIds =
                  StringHelper.getListFromCommaSeparateString(
                      addRequest.store_managers!);
              for (int i = 0; i < resourcesResponse.value.users!.length; i++) {
                if (listIds.contains(
                    resourcesResponse.value.users![i].id.toString())) {
                  resourcesResponse.value.users![i].check = true;
                }
              }
            }
          } else {
            AppUtils.showSnackBarMessage(response.Message!);
          }
        } else {
          AppUtils.showSnackBarMessage(responseModel.statusMessage!);
        }
      },
      onError: (ResponseModel error) {
        isLoading.value = false;
        // isMainViewVisible.value = true;
        if (error.statusCode == ApiConstants.CODE_NO_INTERNET_CONNECTION) {
          AppUtils.showSnackBarMessage('no_internet'.tr);
        } else if (error.statusMessage!.isNotEmpty) {
          AppUtils.showSnackBarMessage(error.statusMessage!);
        }
      },
    );
  }

  void storeStoreApi() async {
    Map<String, dynamic> map = {};
    map["id"] = addRequest.id;
    map["store_name"] = addRequest.store_name;
    map["email"] = addRequest.email;
    map["phone"] = addRequest.phone;
    map["phone_extension_id"] = addRequest.phone_extension_id.toString();
    map["phone_extension"] = addRequest.phone_extension;
    map["address"] = addRequest.address;
    map["street"] = addRequest.street;
    map["location"] = addRequest.location;
    map["town"] = addRequest.town;
    map["postcode"] = addRequest.postcode;
    map["store_managers"] = addRequest.store_managers;
    // map["status"] = addRequest.status;
    map["status"] = true;
    map["mode_type"] = addRequest.mode_type;
    multi.FormData formData = multi.FormData.fromMap(map);

    print("Request Data:" + map.toString());

    isLoading.value = true;

    _api.storeStore(
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
