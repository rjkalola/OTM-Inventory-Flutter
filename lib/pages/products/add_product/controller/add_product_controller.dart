import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart' as multi;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:otm_inventory/pages/common/select_Item_list_dialog.dart';
import 'package:otm_inventory/pages/products/add_product/model/product_details_response.dart';
import 'package:otm_inventory/utils/string_helper.dart';
import 'package:otm_inventory/web_services/response/base_response.dart';
import 'package:otm_inventory/web_services/response/module_info.dart';

import '../../../../routes/app_routes.dart';
import '../../../../utils/AlertDialogHelper.dart';
import '../../../../utils/app_constants.dart';
import '../../../../utils/app_utils.dart';
import '../../../../web_services/api_constants.dart';
import '../../../../web_services/response/response_model.dart';
import '../../../common/drop_down_list_dialog.dart';
import '../../../common/listener/DialogButtonClickListener.dart';
import '../../../common/listener/select_item_listener.dart';
import '../../../common/model/file_info.dart';
import '../../../stock_list/stock_list_repository.dart';
import '../../product_list/models/product_image_info.dart';
import '../../product_list/models/product_info.dart';
import '../model/add_product_request.dart';
import '../model/product_resources_response.dart';
import '../model/store_stock_product_response.dart';
import 'add_product_repository.dart';

class AddProductController extends GetxController
    implements SelectItemListener, DialogButtonClickListener {
  RxBool isLoading = false.obs,
      isInternetNotAvailable = false.obs,
      isMainViewVisible = false.obs,
      isStatus = true.obs,
      isDeleteVisible = false.obs;
  RxString title = ''.obs, mInitialBarcode = "".obs;
  var mBarCode = "", productId = "";
  final formKey = GlobalKey<FormState>();
  final _api = AddProductRepository();
  final productResourcesResponse = ProductResourcesResponse().obs;
  final addProductRequest = AddProductRequest();
  var filesList = <FilesInfo>[].obs;
  var selectedImageIndex = 0;

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
  final productBarcodeController = TextEditingController().obs;

  final ImagePicker _picker = ImagePicker();

  @override
  void onInit() {
    super.onInit();
    var arguments = Get.arguments;
    if (arguments != null) {
      title.value = 'edit_product'.tr;
      // ProductInfo? info = arguments[AppConstants.intentKey.productInfo];
      // if (info != null) {
      //   print("info.id:" + info.id.toString());
      //   print("product name:" + info.name!);
      //   setProductDetails(info);
      // } else {
      productId = arguments[AppConstants.intentKey.productId];
      getProductDetails(productId);
      // }
    } else {
      FilesInfo info = FilesInfo();
      filesList.add(info);

      title.value = 'add_product'.tr;
      addProductRequest.categories = [];
    }

    // FileInfo info1 = FileInfo();
    // info1.file =
    //     "https://fastly.picsum.photos/id/68/536/354.jpg?hmac=1HfgJb31lF-wUi81l2uZsAMfntViiCV9z5_ntQvW3Ks";
    // filesList.add(info1);

    getProductResourcesApi();
  }

  void setProductDetails(ProductInfo info) {
    isDeleteVisible.value = true;
    addProductRequest.categories = [];
    addProductRequest.id = info.id ?? 0;
    addProductRequest.supplier_id = info.supplierId ?? 0;
    addProductRequest.lengthUnit_id = info.length_unit_id ?? 0;
    addProductRequest.weightUnit_id = info.weight_unit_id ?? 0;
    addProductRequest.manufacturer_id = info.manufacturer_id ?? 0;
    addProductRequest.model_id = info.model_id ?? 0;
    if (info.categories != null && info.categories!.isNotEmpty) {
      productCategoryController.value.text = info.categories![0].name ?? "";
      for (int i = 0; i < info.categories!.length; i++) {
        addProductRequest.categories!.add(info.categories![i].id.toString());
      }
    }
    productTitleController.value.text = info.shortName ?? "";
    productNameController.value.text = info.name ?? "";
    productLengthController.value.text = info.length ?? "";
    productWidthController.value.text = info.width ?? "";
    productHeightController.value.text = info.height ?? "";
    productWeightController.value.text = info.weight ?? "";
    productManufacturerController.value.text = info.manufacturer_name ?? "";
    productModelController.value.text = info.model_name ?? "";
    productSKUController.value.text = info.sku ?? "";
    productPriceController.value.text = info.price ?? "";
    productTaxController.value.text = info.tax ?? "";
    productDescriptionController.value.text = info.description ?? "";
    productSupplierController.value.text = info.supplier_name ?? "";
    productLengthUnitController.value.text = info.length_unit_name ?? "";
    productWeightUnitController.value.text = info.weight_unit_name ?? "";
    productBarcodeController.value.text = info.barcode_text ?? "";
    mInitialBarcode.value = info.barcode_text ?? "";

    isStatus.value = info.status ?? false;
  }

  void onSubmitClick() {
    if (formKey.currentState!.validate()) {
      addProductRequest.shortName =
          productTitleController.value.text.toString().trim();
      addProductRequest.name =
          productNameController.value.text.toString().trim();
      addProductRequest.length =
          productLengthController.value.text.toString().trim();
      addProductRequest.width =
          productWidthController.value.text.toString().trim();
      addProductRequest.height =
          productHeightController.value.text.toString().trim();
      addProductRequest.weight =
          productWeightController.value.text.toString().trim();
      productModelController.value.text.toString().trim();
      addProductRequest.sku = productSKUController.value.text.toString().trim();
      addProductRequest.price =
          productPriceController.value.text.toString().trim();
      addProductRequest.tax = productTaxController.value.text.toString().trim();
      addProductRequest.description =
          productDescriptionController.value.text.toString().trim();
      addProductRequest.barcode_text =
          productBarcodeController.value.text.toString().trim();

      if (addProductRequest.id != null && addProductRequest.id != 0) {
        addProductRequest.mode_type = 2;
      } else {
        addProductRequest.mode_type = 1;
      }

      addProductRequest.status = isStatus.value;
      storeProductApi();
    }
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

  void showModelList() {
    if (productResourcesResponse.value.model != null &&
        productResourcesResponse.value.model!.isNotEmpty) {
      showDropDownDialog(AppConstants.dialogIdentifier.modelList, 'model'.tr,
          productResourcesResponse.value.model!, this);
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
    if (action == AppConstants.dialogIdentifier.categoryList) {
      productCategoryController.value.text = name;
      addProductRequest.categories!.add(id.toString());
    } else if (action == AppConstants.dialogIdentifier.supplierList) {
      productSupplierController.value.text = name;
      addProductRequest.supplier_id = id;
    } else if (action == AppConstants.dialogIdentifier.lengthUnitList) {
      productLengthUnitController.value.text = name;
      addProductRequest.lengthUnit_id = id;
    } else if (action == AppConstants.dialogIdentifier.weightUnitList) {
      productWeightUnitController.value.text = name;
      addProductRequest.weightUnit_id = id;
    } else if (action == AppConstants.dialogIdentifier.manufacturerList) {
      productManufacturerController.value.text = name;
      addProductRequest.manufacturer_id = id;
    } else if (action == AppConstants.dialogIdentifier.modelList) {
      productModelController.value.text = name;
      addProductRequest.model_id = id;
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

  // Future showOptions(String dialogType, String title,
  //     List<ModuleInfo> list, SelectItemListener listener) async {
  //   showCupertinoModalPopup(
  //     context: Get.context!,
  //     builder: (context) => SelectItemListDialog(
  //         title: title,
  //         dialogType: dialogType,
  //         list: list,
  //         listener: listener),
  //   );
  // }

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

  onSelectPhoto(index) async {
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
    if (filesList[index].id != null && filesList[index].id! > 0) {
      selectedImageIndex = index;
      AlertDialogHelper.showAlertDialog(
          "",
          'delete_item_msg'.tr,
          'yes'.tr,
          'no'.tr,
          "",
          true,
          this,
          AppConstants.dialogIdentifier.deleteProductImage);
    } else {
      filesList.removeAt(index);
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

  void storeProductApi() async {
    Map<String, dynamic> map = {};
    map["id"] = addProductRequest.id;
    map["short_name"] = addProductRequest.shortName;
    map["name"] = addProductRequest.name;
    map["supplier_id"] = addProductRequest.supplier_id;
    map["length"] = addProductRequest.length;
    map["width"] = addProductRequest.width;
    map["height"] = addProductRequest.height;
    map["length_unit_id"] = addProductRequest.lengthUnit_id;
    map["weight"] = addProductRequest.weight;
    map["weight_unit_id"] = addProductRequest.weightUnit_id;
    map["manufacturer_id"] = addProductRequest.manufacturer_id;
    map["model_id"] = addProductRequest.model_id;
    map["sku"] = addProductRequest.sku;
    map["price"] = addProductRequest.price;
    map["tax"] = addProductRequest.tax;
    map["description"] = addProductRequest.description;
    // map["status"] = addProductRequest.status;
    map["status"] = true;
    map["mode_type"] = addProductRequest.mode_type;
    map["barcode_text"] = addProductRequest.barcode_text ?? "";

    if (addProductRequest.categories != null &&
        addProductRequest.categories!.isNotEmpty) {
      for (int i = 0; i < addProductRequest.categories!.length; i++) {
        map['categories[${i.toString()}]'] = addProductRequest.categories![i];
      }
    }

    var list = <FilesInfo>[];
    for (int i = 0; i < filesList.length; i++) {
      if (!StringHelper.isEmptyString(filesList[i].file ?? "") &&
          !filesList[i].file!.startsWith("http")) {
        list.add(filesList[i]);
      }
    }

    // if (list.isNotEmpty) {
    //   for (int i = 0; i < list.length; i++) {
    //     String fileName = list[i].file ?? "".split('/').last;
    //     map["files"] = await multi.MultipartFile.fromFile(list[i].file ?? "",
    //         filename: fileName);
    //   }
    // }

    // var formData = multi.FormData();

    map["mode_type"] = addProductRequest.mode_type;

    multi.FormData formData = multi.FormData.fromMap(map);
    if (list.isNotEmpty) {
      for (var info in list) {
        formData.files.addAll([
          MapEntry(
              "files[]", await multi.MultipartFile.fromFile(info.file ?? "")),
        ]);
      }
    }

    print("Request Data:" + map.toString());
    isLoading.value = true;
    _api.storeProduct(
      formData: formData,
      onSuccess: (ResponseModel responseModel) {
        isLoading.value = false;
        if (responseModel.statusCode == 200) {
          // StoreProductResponse response = StoreProductResponse.fromJson(jsonDecode(responseModel.result!));
          // if (response.IsSuccess!) {
          //  print("Id:${response.info!.id!.toString()}") ;
          // }
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

  void deleteProduct(String ids) async {
    Map<String, dynamic> map = {};
    map["ids"] = ids;
    multi.FormData formData = multi.FormData.fromMap(map);
    print("Request Data:" + map.toString());

    isLoading.value = true;

    _api.deleteProduct(
      formData: formData,
      onSuccess: (ResponseModel responseModel) {
        isLoading.value = false;
        if (responseModel.statusCode == 200) {
          BaseResponse response =
              BaseResponse.fromJson(jsonDecode(responseModel.result!));
          if (response.IsSuccess!) {
            if (!StringHelper.isEmptyString(response.Message ?? "")) {
              AppUtils.showToastMessage(response.Message ?? "");
            }
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

  void deleteProductImage(String id) async {
    Map<String, dynamic> map = {};
    map["attachment_id"] = id;
    multi.FormData formData = multi.FormData.fromMap(map);
    print("Request Data:" + map.toString());

    isLoading.value = true;

    _api.deleteProductImage(
      formData: formData,
      onSuccess: (ResponseModel responseModel) {
        isLoading.value = false;
        if (responseModel.statusCode == 200) {
          BaseResponse response =
              BaseResponse.fromJson(jsonDecode(responseModel.result!));
          if (response.IsSuccess!) {
            if (!StringHelper.isEmptyString(response.Message ?? "")) {
              AppUtils.showToastMessage(response.Message ?? "");
              filesList.removeAt(selectedImageIndex);
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
        if (error.statusCode == ApiConstants.CODE_NO_INTERNET_CONNECTION) {
          AppUtils.showSnackBarMessage('no_internet'.tr);
        } else if (error.statusMessage!.isNotEmpty) {
          AppUtils.showSnackBarMessage(error.statusMessage!);
        }
      },
    );
  }

  void getProductDetails(String id) async {
    Map<String, dynamic> map = {};
    map["id"] = id;
    multi.FormData formData = multi.FormData.fromMap(map);
    print("Request Data:" + map.toString());

    isLoading.value = true;

    _api.getProductDetails(
      formData: formData,
      onSuccess: (ResponseModel responseModel) {
        isLoading.value = false;
        if (responseModel.statusCode == 200) {
          ProductDetailsResponse response = ProductDetailsResponse.fromJson(
              jsonDecode(responseModel.result!));
          if (response.IsSuccess!) {
            setProductDetails(response.info!);
            FilesInfo info = FilesInfo();
            filesList.add(info);

            for (int i = 0; i < response.info!.product_images!.length; i++) {
              ProductImageInfo productImageInfo =
                  response.info!.product_images![i];
              FilesInfo info = FilesInfo();
              info.id = productImageInfo.id;
              info.file = productImageInfo.imageUrl;
              info.fileThumb = productImageInfo.imageThumbUrl;
              filesList.add(info);
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
        if (error.statusCode == ApiConstants.CODE_NO_INTERNET_CONNECTION) {
          AppUtils.showSnackBarMessage('no_internet'.tr);
        } else if (error.statusMessage!.isNotEmpty) {
          AppUtils.showSnackBarMessage(error.statusMessage!);
        }
      },
    );
  }

  void attachBarCodeApi(String message) async {
    Map<String, dynamic> map = {};
    map["id"] = productId;
    map["barcode_text"] = mBarCode;
    multi.FormData formData = multi.FormData.fromMap(map);
    print("Request Data:" + map.toString());

    isLoading.value = true;

    StockListRepository().storeProduct(
      formData: formData,
      onSuccess: (ResponseModel responseModel) {
        isLoading.value = false;
        if (responseModel.statusCode == 200) {
          StoreStockProductResponse response =
              StoreStockProductResponse.fromJson(
                  jsonDecode(responseModel.result!));
          if (response.IsSuccess!) {
            AppUtils.showSnackBarMessage(message);
            mInitialBarcode.value = mBarCode;
            productBarcodeController.value.text = mBarCode;
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

  void onClickRemove() {
    AlertDialogHelper.showAlertDialog("", 'delete_product_msg'.tr, 'yes'.tr,
        'no'.tr, "", true, this, AppConstants.dialogIdentifier.deleteProduct);
  }

  @override
  void onNegativeButtonClicked(String dialogIdentifier) {
    Get.back();
  }

  @override
  void onOtherButtonClicked(String dialogIdentifier) {}

  @override
  void onPositiveButtonClicked(String dialogIdentifier) {
    if (dialogIdentifier == AppConstants.dialogIdentifier.deleteProductImage) {
      Get.back();
      deleteProductImage(filesList[selectedImageIndex].id!.toString());
    } else if (dialogIdentifier ==
        AppConstants.dialogIdentifier.attachBarcodeDialog) {
      Get.back();
      openQrCodeScanner('barcode_attached_success_msg'.tr);
    } else if (dialogIdentifier ==
        AppConstants.dialogIdentifier.updateBarcodeDialog) {
      Get.back();
      openQrCodeScanner('barcode_update_success_msg'.tr);
    } else if (dialogIdentifier ==
        AppConstants.dialogIdentifier.deleteProduct) {
      Get.back();
      deleteProduct(addProductRequest.id!.toString());
    }
  }

  Future<void> openQrCodeScanner(String message) async {
    var code = await Get.toNamed(AppRoutes.qrCodeScannerScreen);
    if (!StringHelper.isEmptyString(code)) {
      mBarCode = code;
      // getStockListApi(true, true, code);
      attachBarCodeApi(message);
    }
  }

  void onClickQrCode() {
    if (!StringHelper.isEmptyString(mInitialBarcode.value)) {
      showUpdateBarcodeDialog();
    } else {
      showAttachBarcodeDialog();
    }
  }

  showAttachBarcodeDialog() {
    AlertDialogHelper.showAlertDialog(
        "",
        'msg_attach_barcode'.tr,
        'yes'.tr,
        'no'.tr,
        "",
        true,
        this,
        AppConstants.dialogIdentifier.attachBarcodeDialog);
  }

  showUpdateBarcodeDialog() {
    AlertDialogHelper.showAlertDialog(
        "",
        'msg_update_barcode'.tr,
        'yes'.tr,
        'no'.tr,
        "",
        true,
        this,
        AppConstants.dialogIdentifier.updateBarcodeDialog);
  }
}
