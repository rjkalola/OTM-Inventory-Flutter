import 'dart:convert';

import 'package:dio/dio.dart' as multi;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:otm_inventory/utils/string_helper.dart';
import 'package:otm_inventory/web_services/response/module_info.dart';

import '../../../../routes/app_routes.dart';
import '../../../../utils/app_constants.dart';
import '../../../../utils/app_utils.dart';
import '../../../../web_services/api_constants.dart';
import '../../../../web_services/response/response_model.dart';
import '../../../common/drop_down_list_dialog.dart';
import '../../../common/listener/select_item_listener.dart';
import '../../../common/model/file_info.dart';
import '../../add_product/model/add_product_request.dart';
import '../../add_product/model/product_resources_response.dart';
import '../../add_product/model/store_product_response.dart';
import 'add_stock_product_repository.dart';

class AddStockProductController extends GetxController
    implements SelectItemListener {
  RxBool isLoading = false.obs,
      isInternetNotAvailable = false.obs,
      isMainViewVisible = false.obs,
      isStatus = true.obs;
  RxString title = ''.obs;
  String mBarCode = "";
  final formKey = GlobalKey<FormState>();
  final _api = AddStockProductRepository();
  final productResourcesResponse = ProductResourcesResponse().obs;
  final addProductRequest = AddProductRequest();
  var filesList = <FileInfo>[].obs;

  final productTitleController = TextEditingController().obs;
  final productNameController = TextEditingController().obs;
  final productSupplierController = TextEditingController().obs;

  final ImagePicker _picker = ImagePicker();

  @override
  void onInit() {
    super.onInit();
    var arguments = Get.arguments;
    if (arguments != null) {
      mBarCode = arguments[AppConstants.intentKey.barCode];
      print("mBarCode:"+mBarCode);
    }
    title.value = 'add_product'.tr;

    FileInfo info = FileInfo();
    filesList.add(info);

    FileInfo info1 = FileInfo();
    info1.file =
        "https://fastly.picsum.photos/id/68/536/354.jpg?hmac=1HfgJb31lF-wUi81l2uZsAMfntViiCV9z5_ntQvW3Ks";
    filesList.add(info1);

    getProductResourcesApi();
  }

  void onSubmitClick() {
    print("onSubmitClick");
    if (formKey.currentState!.validate()) {
      addProductRequest.shortName =
          productTitleController.value.text.toString().trim();
      addProductRequest.name =
          productNameController.value.text.toString().trim();
      addProductRequest.mode_type = 1;
      addProductRequest.status = isStatus.value;
      storeProductApi();
    }
  }

  void showSupplierList() {
    if (productResourcesResponse.value.supplier != null &&
        productResourcesResponse.value.supplier!.isNotEmpty) {
      showDropDownDialog(AppConstants.dialogIdentifier.supplierList,
          'supplier'.tr, productResourcesResponse.value.supplier!, this);
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
            isCloseEnable: true),
        backgroundColor: Colors.transparent,
        isScrollControlled: true);
  }

  @override
  void onSelectItem(int position, int id, String name, String action) {
     if (action == AppConstants.dialogIdentifier.supplierList) {
      productSupplierController.value.text = name;
      addProductRequest.supplier_id = id;
    }
  }

  onSelectPhoto() async {
    print("pickImage");

    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 900,
        maxHeight: 900,
        imageQuality: 90,
      );
      addPhotoToList(pickedFile!.path ?? "");
      print("Path:" + pickedFile.path ?? "");
    } catch (e) {
      print("error:" + e.toString());
    }
  }

  addPhotoToList(String? path) {
    if (!StringHelper.isEmptyString(path)) {
      FileInfo info = FileInfo();
      info.file = path;
      filesList.add(info);
      print(filesList.length.toString());
    }
  }

  removePhotoFromList(int index) {
    filesList.removeAt(index);
  }

  Future<void> moveStockEditQuantityScreen(String? productId) async {
    var result;
    if (productId != null) {
      var arguments = {
        AppConstants.intentKey.productId: productId,
      };
      result =
      await Get.toNamed(AppRoutes.stockEditQuantityScreen, arguments: arguments);
    }
    Get.back(result: true);
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

  void storeProductApi() async {
    Map<String, dynamic> map = {};
    map["id"] = addProductRequest.id;
    map["shortName"] = addProductRequest.shortName;
    map["name"] = addProductRequest.name;
    map["supplier_id"] = addProductRequest.supplier_id;
    map["status"] = addProductRequest.status;
    map["mode_type"] = addProductRequest.mode_type;
    map["barcode_text"] = mBarCode;
    map["categories[0]"] = "9";
    multi.FormData formData = multi.FormData.fromMap(map);

    print("Request Data:" + map.toString());

    isLoading.value = true;

    _api.storeProduct(
      formData: formData,
      onSuccess: (ResponseModel responseModel) {
        isLoading.value = false;
        if (responseModel.statusCode == 200) {
          // BaseResponse response =
          //     BaseResponse.fromJson(jsonDecode(responseModel.result!));
          StoreProductResponse response = StoreProductResponse.fromJson(jsonDecode(responseModel.result!));
          if (response.IsSuccess!) {
            moveStockEditQuantityScreen(response.info!.id!.toString());
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
