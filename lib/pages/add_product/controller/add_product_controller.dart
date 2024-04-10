import 'dart:convert';

import 'package:dio/dio.dart' as multi;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/add_product/model/product_resources_response.dart';
import 'package:otm_inventory/web_services/response/module_info.dart';

import '../../../utils/app_constants.dart';
import '../../../utils/app_utils.dart';
import '../../../web_services/api_constants.dart';
import '../../../web_services/response/response_model.dart';
import '../../common/drop_down_list_dialog.dart';
import '../../common/listener/select_item_listener.dart';
import '../model/add_product_request.dart';
import 'add_product_repository.dart';

class AddProductController extends GetxController
    implements SelectItemListener {
  RxBool isLoading = false.obs,
      isInternetNotAvailable = false.obs,
      isMainViewVisible = false.obs;
  final formKey = GlobalKey<FormState>();
  final _api = AddProductRepository();
  final productResourcesResponse = ProductResourcesResponse().obs;
  final addProductRequest = AddProductRequest().obs;

  final productTitleController = TextEditingController().obs;
  final productNameController = TextEditingController().obs;
  final productCategoryController = TextEditingController().obs;
  final productSupplierController = TextEditingController().obs;
  final productLengthController = TextEditingController().obs;
  final productWidthController = TextEditingController().obs;
  final productHeightController = TextEditingController().obs;
  final productLengthUnitController = TextEditingController().obs;
  final productWeightController = TextEditingController().obs;
  final productWeightUnitController = TextEditingController().obs;
  final productManufacturerController = TextEditingController().obs;
  final productModelController = TextEditingController().obs;
  final productSKUController = TextEditingController().obs;
  final productPriceController = TextEditingController().obs;
  final productTaxController = TextEditingController().obs;
  final productDescriptionController = TextEditingController().obs;

  @override
  void onInit() {
    super.onInit();
    getProductResourcesApi();
  }

  void onSubmitClick() {
    if (formKey.currentState!.validate()) {}
  }

  void showCategoryList() {
    if (productResourcesResponse.value.categories != null &&
        productResourcesResponse.value.categories!.isNotEmpty) {
      showDropDownDialog(AppConstants.dialogIdentifier.categoryList,
          'category'.tr, productResourcesResponse.value.categories!, this);
    }
  }

  void showSupplierList() {
    if (productResourcesResponse.value.supplier != null &&
        productResourcesResponse.value.supplier!.isNotEmpty) {
      showDropDownDialog(AppConstants.dialogIdentifier.supplierList,
          'supplier'.tr, productResourcesResponse.value.supplier!, this);
    }
  }

  void showLengthList() {
    if (productResourcesResponse.value.lengthUnit != null &&
        productResourcesResponse.value.lengthUnit!.isNotEmpty) {
      showDropDownDialog(AppConstants.dialogIdentifier.lengthUnitList,
          'length_unit'.tr, productResourcesResponse.value.lengthUnit!, this);
    }
  }

  void showWeightList() {
    if (productResourcesResponse.value.weightUnit != null &&
        productResourcesResponse.value.weightUnit!.isNotEmpty) {
      showDropDownDialog(AppConstants.dialogIdentifier.weightUnitList,
          'weight_unit'.tr, productResourcesResponse.value.weightUnit!, this);
    }
  }

  void showDropDownDialog(String dialogType, String title,
      List<ModuleInfo> list, SelectItemListener listener) {
    Get.bottomSheet(
        DropDownListDialog(
            title: title,
            dialogType: dialogType,
            list: list,
            listener: listener),
        backgroundColor: Colors.transparent,
        isScrollControlled: true);
  }

  @override
  void onSelectItem(int position, int id, String name, String action) {
    if (action == AppConstants.dialogIdentifier.categoryList) {
      productCategoryController.value.text = name;
    } else if (action == AppConstants.dialogIdentifier.supplierList) {
      productSupplierController.value.text = name;
    }else if (action == AppConstants.dialogIdentifier.lengthUnitList) {
      productLengthUnitController.value.text = name;
    }else if (action == AppConstants.dialogIdentifier.weightUnitList) {
      productWeightUnitController.value.text = name;
    }
  }

  void getProductResourcesApi() async {
    Map<String, dynamic> map = {};
    multi.FormData formData = multi.FormData.fromMap(map);
    isLoading.value = true;

    _api.getProductResources(
      formData: formData,
      onSuccess: (ResponseModel responseModel) {
        isLoading.value = false;
        if (responseModel.statusCode == 200) {
          ProductResourcesResponse response = ProductResourcesResponse.fromJson(
              jsonDecode(responseModel.result!));
          if (response.IsSuccess!) {
            productResourcesResponse.value = response;
            isMainViewVisible.value = true;
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
}
