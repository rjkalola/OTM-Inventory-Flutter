import 'dart:convert';

import 'package:dio/dio.dart' as multi;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/add_supplier/add_supplier_repository.dart';
import 'package:otm_inventory/pages/add_supplier/models/add_supplier_request.dart';
import 'package:otm_inventory/pages/add_supplier/models/supplier_resources_response.dart';
import 'package:otm_inventory/pages/supplier_list/model/supplier_info.dart';
import 'package:otm_inventory/web_services/response/base_response.dart';
import 'package:otm_inventory/web_services/response/module_info.dart';

import '../../../utils/app_utils.dart';
import '../../../web_services/api_constants.dart';
import '../../../web_services/response/response_model.dart';
import '../../utils/app_constants.dart';
import '../common/drop_down_list_dialog.dart';
import '../common/listener/SelectPhoneExtensionListener.dart';
import '../common/listener/select_item_listener.dart';
import '../common/phone_extension_list_dialog.dart';

class AddSupplierController extends GetxController
    implements SelectItemListener, SelectPhoneExtensionListener {
  RxBool isLoading = false.obs,
      isInternetNotAvailable = false.obs,
      isMainViewVisible = false.obs,
      isStatus = true.obs,
      isSaveEnable = false.obs;
  RxString title = ''.obs;
  final mExtension = "".obs;
  final mFlag = "".obs;
  final formKey = GlobalKey<FormState>();
  final _api = AddSupplierRepository();
  final resourcesResponse = SupplierResourcesResponse().obs;
  final addRequest = AddSupplierRequest();

  final contactNameController = TextEditingController().obs;
  final emailController = TextEditingController().obs;
  final phoneExtensionController = TextEditingController().obs;
  final phoneNumberController = TextEditingController().obs;
  final addressController = TextEditingController().obs;
  final companyNameController = TextEditingController().obs;
  final weightController = TextEditingController().obs;
  final weightUnitController = TextEditingController().obs;
  final accountNumberController = TextEditingController().obs;
  final streetController = TextEditingController().obs;
  final townController = TextEditingController().obs;
  final postcodeController = TextEditingController().obs;

  @override
  void onInit() {
    super.onInit();
    var arguments = Get.arguments;
    if (arguments != null) {
      title.value = 'edit_supplier'.tr;
      SupplierInfo info = arguments[AppConstants.intentKey.supplierInfo];
      addRequest.id = info.id ?? 0;
      addRequest.phone_extension_id =
          info.phoneExtensionId ?? AppConstants.defaultPhoneExtensionId;
      addRequest.phone_extension =
          info.phoneExtensionName ?? AppConstants.defaultPhoneExtension;
      addRequest.weight_unit_id = info.weightUnitId ?? 0;

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
      contactNameController.value.text = info.contactName ?? "";
      emailController.value.text = info.email ?? "";
      weightController.value.text = info.weight ?? "";
      weightUnitController.value.text = info.weightUnitName ?? "";
      companyNameController.value.text = info.companyName ?? "";
      accountNumberController.value.text = info.account_number ?? "";
      isStatus.value = info.status ?? false;
    } else {
      title.value = 'add_supplier'.tr;
      mExtension.value = AppConstants.defaultPhoneExtension;
      mFlag.value = AppConstants.defaultFlagUrl;

      addRequest.phone_extension_id = AppConstants.defaultPhoneExtensionId;
      addRequest.phone_extension = AppConstants.defaultPhoneExtension;
    }
    getSupplierResourcesApi();
  }

  void onSubmitClick() {
    if (formKey.currentState!.validate()) {
      if (isSaveEnable.value) {
        addRequest.contact_name =
            contactNameController.value.text.toString().trim();
        addRequest.email = emailController.value.text.toString().trim();
        addRequest.phone = phoneNumberController.value.text.toString().trim();
        addRequest.company_name =
            companyNameController.value.text.toString().trim();
        // addRequest.address = addressController.value.text.toString().trim();
        // addRequest.weight = weightController.value.text.toString().trim();
        addRequest.account_number =
            accountNumberController.value.text.toString().trim();
        addRequest.street = streetController.value.text.toString().trim();
        addRequest.location = addressController.value.text.toString().trim();
        addRequest.town = townController.value.text.toString().trim();
        addRequest.postcode = postcodeController.value.text.toString().trim();

        if (addRequest.id != null && addRequest.id != 0) {
          addRequest.mode_type = 2;
        } else {
          addRequest.mode_type = 1;
        }

        addRequest.status = isStatus.value;

        storeSupplierApi();
      } else {
        Get.back();
      }
    }
  }

  void showWeightList() {
    if (resourcesResponse.value.weightUnit != null &&
        resourcesResponse.value.weightUnit!.isNotEmpty) {
      showDropDownDialog(AppConstants.dialogIdentifier.weightUnitList,
          'weight_unit'.tr, resourcesResponse.value.weightUnit!, this);
    }
  }

  void showDropDownDialog(String dialogType, String title,
      List<ModuleInfo> list, SelectItemListener listener) {
    Get.bottomSheet(
        DropDownListDialog(
          title: title,
          dialogType: dialogType,
          list: list,
          listener: listener,
          isCloseEnable: true,
          isSearchEnable: true,
        ),
        backgroundColor: Colors.transparent,
        isScrollControlled: true);
  }

  @override
  void onSelectItem(int position, int id, String name, String action) {
    if (action == AppConstants.dialogIdentifier.weightUnitList) {
      weightUnitController.value.text = name;
      addRequest.weight_unit_id = id;
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

  void getSupplierResourcesApi() async {
    Map<String, dynamic> map = {};
    multi.FormData formData = multi.FormData.fromMap(map);
    isLoading.value = true;

    _api.getSupplierResources(
      formData: formData,
      onSuccess: (ResponseModel responseModel) {
        isLoading.value = false;
        if (responseModel.statusCode == 200) {
          SupplierResourcesResponse response =
              SupplierResourcesResponse.fromJson(
                  jsonDecode(responseModel.result!));
          if (response.IsSuccess!) {
            resourcesResponse.value = response;
            isMainViewVisible.value = true;
            // if (addRequest.phone_extension_id == null ||
            //     addRequest.phone_extension_id! == 0) {
            //   for (int i = 0;
            //       i < resourcesResponse.value.countries!.length;
            //       i++) {
            //     if (resourcesResponse.value.countries![i].phoneExtension ==
            //         "+91") {
            //       addRequest.phone_extension_id =
            //           resourcesResponse.value.countries![i].id;
            //       addRequest.phone_extension =
            //           resourcesResponse.value.countries![i].phoneExtension!;
            //       break;
            //     }
            //   }
            // }
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

  void storeSupplierApi() async {
    Map<String, dynamic> map = {};
    map["id"] = addRequest.id;
    map["contact_name"] = addRequest.contact_name;
    map["email"] = addRequest.email;
    map["phone"] = addRequest.phone;
    map["phone_extension_id"] = addRequest.phone_extension_id.toString();
    map["phone_extension"] = addRequest.phone_extension;
    map["street"] = addRequest.street;
    map["address"] = addRequest.address;
    map["location"] = addRequest.location;
    map["town"] = addRequest.town;
    map["postcode"] = addRequest.postcode;
    map["company_name"] = addRequest.company_name;
    // map["weight"] = addRequest.weight;
    // map["weight_unit_id"] = addRequest.weight_unit_id;
    map["account_number"] = addRequest.account_number;
    // map["status"] = addRequest.status;
    map["status"] = true;
    map["mode_type"] = addRequest.mode_type;
    multi.FormData formData = multi.FormData.fromMap(map);

    print("Request Data:" + map.toString());

    isLoading.value = true;

    _api.storeSupplier(
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
