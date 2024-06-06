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
import '../../../../utils/app_storage.dart';
import '../../../../utils/app_utils.dart';
import '../../../../web_services/api_constants.dart';
import '../../../../web_services/response/response_model.dart';
import '../../../common/drop_down_list_dialog.dart';
import '../../../common/listener/select_item_listener.dart';
import '../../../common/model/file_info.dart';
import '../../../common/select_Item_list_dialog.dart';
import '../../add_product/model/add_product_request.dart';
import '../../add_product/model/product_resources_response.dart';
import '../../add_product/model/store_product_response.dart';
import '../../product_list/models/product_image_info.dart';
import '../../product_list/models/product_info.dart';
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
  var filesList = <FilesInfo>[].obs;

  final productTitleController = TextEditingController().obs;
  final productNameController = TextEditingController().obs;
  final productSupplierController = TextEditingController().obs;
  final productManufacturerController = TextEditingController().obs;
  final productPriceController = TextEditingController().obs;
  final productDescriptionController = TextEditingController().obs;
  final productBarcodeController = TextEditingController().obs;

  final ImagePicker _picker = ImagePicker();

  @override
  Future<void> onInit() async {
    super.onInit();

    FilesInfo info = FilesInfo();
    filesList.add(info);

    var arguments = Get.arguments;
    if (arguments != null) {
      mBarCode = arguments[AppConstants.intentKey.barCode] ?? "";
      ProductInfo? info = arguments[AppConstants.intentKey.productInfo];
      if (info != null) {
        title.value = 'edit_product'.tr;
        setProductDetails(info);
      } else {
        title.value = 'add_product'.tr;
      }
    } else {
      title.value = 'add_product'.tr;
    }

    // FileInfo info1 = FileInfo();
    // info1.file =
    //     "https://fastly.picsum.photos/id/68/536/354.jpg?hmac=1HfgJb31lF-wUi81l2uZsAMfntViiCV9z5_ntQvW3Ks";
    // filesList.add(info1);

    // bool isInternet = await AppUtils.interNetCheck();
    // if (isInternet) {
    //   getProductResourcesApi();
    // } else {
    if (AppStorage().getProductResources() != null) {
      productResourcesResponse.value = AppStorage().getProductResources()!;
      isMainViewVisible.value = true;
    }
    // }
  }

  void setProductDetails(ProductInfo info) {
    addProductRequest.categories = [];
    addProductRequest.id = info.id ?? 0;
    addProductRequest.supplier_id = info.supplierId ?? 0;
    addProductRequest.lengthUnit_id = info.length_unit_id ?? 0;
    addProductRequest.weightUnit_id = info.weight_unit_id ?? 0;
    addProductRequest.manufacturer_id = info.manufacturer_id ?? 0;
    addProductRequest.model_id = info.model_id ?? 0;
    productTitleController.value.text = info.shortName ?? "";
    productNameController.value.text = info.name ?? "";
    productManufacturerController.value.text = info.manufacturer_name ?? "";
    productPriceController.value.text = info.price ?? "";
    productDescriptionController.value.text = info.description ?? "";
    productSupplierController.value.text = info.supplier_name ?? "";
    productBarcodeController.value.text = info.barcode_text ?? "";
    mBarCode = info.barcode_text ?? "";
    isStatus.value = info.status ?? false;

    for (int i = 0; i < info.product_images!.length; i++) {
      ProductImageInfo productImageInfo = info.product_images![i];
      FilesInfo fileInfo = FilesInfo();
      fileInfo.id = productImageInfo.id;
      fileInfo.file = productImageInfo.imageUrl;
      fileInfo.fileThumb = productImageInfo.imageThumbUrl;
      filesList.add(fileInfo);
    }
  }

  void onSubmitClick() {
    if (formKey.currentState!.validate()) {
      addProductRequest.shortName =
          productTitleController.value.text.toString().trim();
      addProductRequest.name =
          productNameController.value.text.toString().trim();
      addProductRequest.price =
          productPriceController.value.text.toString().trim();
      addProductRequest.description =
          productDescriptionController.value.text.toString().trim();
      addProductRequest.barcode_text =
          productBarcodeController.value.text.toString().trim();
      // addProductRequest.mode_type = 1;
      if (addProductRequest.id != null && addProductRequest.id != 0) {
        addProductRequest.mode_type = 2;
      } else {
        addProductRequest.mode_type = 1;
      }
      addProductRequest.status = isStatus.value;
      filesList.removeAt(0);
      addProductRequest.product_images = filesList;

      List<AddProductRequest> list = AppStorage().getStoredProductList();
      if (addProductRequest.id != null && addProductRequest.id! != 0) {
        int index = -1;
        for (int i = 0; i < list.length; i++) {
          if (list[i].id == addProductRequest.id!) {
            index = i;
            break;
          }
        }
        print("index:" + index.toString());
        if (index != -1) {
          list[index] = addProductRequest;
        } else {
          list.add(addProductRequest);
        }
      } else {
        list.add(addProductRequest);
      }
      print("List Size:" + list.length.toString());
      AppStorage().setStoredProductList(list);
      Get.back(result: true);
      // storeProductApi();
    }
  }

  void showSupplierList() {
    if (productResourcesResponse.value.supplier != null &&
        productResourcesResponse.value.supplier!.isNotEmpty) {
      showDropDownDialog(AppConstants.dialogIdentifier.supplierList,
          'supplier'.tr, productResourcesResponse.value.supplier!, this);
    }
  }

  void showManufacturerList() {
    if (productResourcesResponse.value.manufacturer != null &&
        productResourcesResponse.value.manufacturer!.isNotEmpty) {
      showDropDownDialog(
          AppConstants.dialogIdentifier.manufacturerList,
          'manufacturer'.tr,
          productResourcesResponse.value.manufacturer!,
          this);
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
    } else if (action == AppConstants.dialogIdentifier.manufacturerList) {
      productManufacturerController.value.text = name;
      addProductRequest.manufacturer_id = id;
    } else if (action == AppConstants.action.selectImageFromCamera ||
        action == AppConstants.action.selectImageFromGallery) {
      selectImage(action);
    }
  }

  void selectImage(String action) async {
    try {
      XFile? pickedFile;
      if (action == AppConstants.action.selectImageFromCamera) {
        pickedFile = await _picker.pickImage(
          source: ImageSource.camera,
          maxWidth: 900,
          maxHeight: 900,
          imageQuality: 90,
        );
      } else if (action == AppConstants.action.selectImageFromGallery) {
        pickedFile = await _picker.pickImage(
          source: ImageSource.gallery,
          maxWidth: 900,
          maxHeight: 900,
          imageQuality: 90,
        );
      }

      if (pickedFile != null) {
        addPhotoToList(pickedFile!.path ?? "");
        print("Path:" + pickedFile.path ?? "");
      }
    } catch (e) {
      print("error:" + e.toString());
    }
  }

  void showAttachmentOptionsDialog(String dialogType, String title,
      List<ModuleInfo> list, SelectItemListener listener) {
    Get.bottomSheet(
        SelectItemListDialog(
            title: title,
            dialogType: dialogType,
            list: list,
            listener: listener),
        backgroundColor: Colors.transparent,
        enableDrag: false,
        isScrollControlled: false);
  }

  onSelectPhoto(int index) async {
    print("pickImage");
    if (index == 0) {
      var listOptions = <ModuleInfo>[].obs;
      ModuleInfo? info;

      info = ModuleInfo();
      info.name = 'camera'.tr;
      info.action = AppConstants.action.selectImageFromCamera;
      listOptions.add(info);

      info = ModuleInfo();
      info.name = 'gallery'.tr;
      info.action = AppConstants.action.selectImageFromGallery;
      listOptions.add(info);

      // showAttachmentOptionsDialog(
      //     AppConstants.dialogIdentifier.attachmentOptionsList,
      //     'select_photo'.tr,
      //     listOptions,
      //     this);

      showAttachmentOptionsDialog(
          AppConstants.dialogIdentifier.attachmentOptionsList,
          'select_photo_from_'.tr,
          listOptions,
          this);
    } else {}
  }

  addPhotoToList(String? path) {
    if (!StringHelper.isEmptyString(path)) {
      FilesInfo info = FilesInfo();
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
      result = await Get.toNamed(AppRoutes.stockEditQuantityScreen,
          arguments: arguments);
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
    // map["categories[0]"] = "9";
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
          StoreProductResponse response =
              StoreProductResponse.fromJson(jsonDecode(responseModel.result!));
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
