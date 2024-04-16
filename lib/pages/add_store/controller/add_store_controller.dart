import 'dart:convert';

import 'package:dio/dio.dart' as multi;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
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
      isStatus = true.obs;
  RxString title = ''.obs;
  final mExtension = "+91".obs;
  final mFlag = "https://cdn.otmsystem.com//flags//png//in_32.png".obs;
  final formKey = GlobalKey<FormState>();
  final _api = AddStoreRepository();
  final resourcesResponse = StoreResourcesResponse().obs;
  final addRequest = AddStoreRequest();

  final storeNameController = TextEditingController().obs;
  final phoneExtensionController = TextEditingController().obs;
  final phoneNumberController = TextEditingController().obs;
  final addressController = TextEditingController().obs;
  final storeManagerController = TextEditingController().obs;

  @override
  void onInit() {
    super.onInit();
    var arguments = Get.arguments;
    if (arguments != null) {
      title.value = 'edit_store'.tr;
      StoreInfo info = arguments[AppConstants.intentKey.storeInfo];
      print("info.id:"+info.id.toString());
      print("store name:"+info.storeName!);

      addRequest.id = info.id??0;
      addRequest.store_name = info.storeName??"";
      addRequest.phone_extension_id = info.phoneExtensionId??0;
      addRequest.phone_extension = info.phoneWithExtension??"";
      addRequest.phone = info.phone??"";
      addRequest.address = info.address??"";

      storeNameController.value.text = info.storeName??"";
      mExtension.value = info.phoneWithExtension??"";

      phoneExtensionController.value.text = info.phoneWithExtension??"";
      phoneNumberController.value.text = info.phone??"";
      addressController.value.text = info.address??"";

      isStatus.value = info.status??false;
    } else {
      title.value = 'add_store'.tr;
      addRequest.phone_extension = mExtension.value;
    }
    getStoreResourcesApi();
  }

  void onSubmitClick() {
    if (formKey.currentState!.validate()) {
      addRequest.store_name = storeNameController.value.text.toString().trim();
      addRequest.phone = phoneNumberController.value.text.toString().trim();
      addRequest.address = addressController.value.text.toString().trim();

      if (addRequest.id != null && addRequest.id != 0) {
        addRequest.mode_type = 2;
      } else {
        addRequest.mode_type = 1;
      }

      addRequest.status = isStatus.value;

      storeStoreApi();
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
            if (addRequest.phone_extension_id == null ||
                addRequest.phone_extension_id! == 0) {
              for (int i = 0;
                  i < resourcesResponse.value.countries!.length;
                  i++) {
                if (resourcesResponse.value.countries![i].phoneExtension ==
                    "+91") {
                  addRequest.phone_extension_id =
                      resourcesResponse.value.countries![i].id;
                  addRequest.phone_extension =
                      resourcesResponse.value.countries![i].phoneExtension!;
                  break;
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
    map["phone"] = addRequest.phone;
    map["phone_extension_id"] = addRequest.phone_extension_id.toString();
    map["phone_extension"] = addRequest.phone_extension;
    map["address"] = addRequest.address;
    map["store_managers"] = addRequest.store_managers;
    map["status"] = addRequest.status;
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
}
