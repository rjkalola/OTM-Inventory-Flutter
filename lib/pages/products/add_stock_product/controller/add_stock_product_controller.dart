import 'dart:convert';

import 'package:dio/dio.dart' as multi;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:otm_inventory/utils/string_helper.dart';
import 'package:otm_inventory/web_services/response/module_info.dart';

import '../../../../routes/app_routes.dart';
import '../../../../utils/app_constants.dart';
import '../../../../utils/app_storage.dart';
import '../../../../utils/app_utils.dart';
import '../../../../utils/image_utils.dart';
import '../../../../web_services/api_constants.dart';
import '../../../../web_services/response/response_model.dart';
import '../../../common/drop_down_list_dialog.dart';
import '../../../common/drop_down_multi_selection_list_dialog.dart';
import '../../../common/listener/select_item_listener.dart';
import '../../../common/listener/select_multi_item_listener.dart';
import '../../../common/model/file_info.dart';
import '../../../common/select_Item_list_dialog.dart';
import '../../../stock_list/stock_list_repository.dart';
import '../../add_product/model/product_resources_response.dart';
import '../../add_product/model/store_product_response.dart';
import '../../product_list/models/product_image_info.dart';
import '../../product_list/models/product_info.dart';
import '../../product_list/models/product_list_response.dart';
import 'add_stock_product_repository.dart';

class AddStockProductController extends GetxController
    implements SelectItemListener, SelectMultiItemListener {
  RxBool isLoading = false.obs,
      isInternetNotAvailable = false.obs,
      isMainViewVisible = false.obs,
      isStatus = true.obs,
      isSaveEnable = false.obs;
  RxString title = ''.obs;
  String mBarCode = "";
  final formKey = GlobalKey<FormState>();
  final _api = AddStockProductRepository();
  final productResourcesResponse = ProductResourcesResponse().obs;
  ProductInfo? addProductRequest;
  var filesList = <FilesInfo>[].obs;

  final productTitleController = TextEditingController().obs;
  final productNameController = TextEditingController().obs;
  final productSupplierController = TextEditingController().obs;
  final productManufacturerController = TextEditingController().obs;
  final productPriceController = TextEditingController().obs;
  final productCutoffController = TextEditingController().obs;
  final productDescriptionController = TextEditingController().obs;
  final productBarcodeController = TextEditingController().obs;
  final productCategoryController = TextEditingController().obs;
  final productUuidController = TextEditingController().obs;

  final ImagePicker _picker = ImagePicker();
  String thumbImage = "";

  @override
  Future<void> onInit() async {
    super.onInit();

    if (AppStorage().getProductResources() != null) {
      productResourcesResponse.value = AppStorage().getProductResources()!;
      isMainViewVisible.value = true;
    }

    var arguments = Get.arguments;
    if (arguments != null) {
      mBarCode = arguments[AppConstants.intentKey.barCode] ?? "";
      addProductRequest = arguments[AppConstants.intentKey.productInfo];
      if (addProductRequest != null) {
        FilesInfo info = FilesInfo();
        filesList.add(info);
        // print("localId-----:${addProductRequest?.local_id!}");
        title.value = 'edit_product'.tr;
        setProductDetails(addProductRequest!);
      } else {
        addProductRequest = ProductInfo();
        addProductRequest?.id = 0;
        addProductRequest?.local_id = 0;
        addProductRequest?.qty = 0;
        title.value = 'add_product'.tr;
        if (!StringHelper.isEmptyString(mBarCode))
          productBarcodeController.value.text = mBarCode;
        addProductRequest?.categories = [];

        FilesInfo info = FilesInfo();
        filesList.add(info);
      }
    } else {
      addProductRequest = ProductInfo();
      addProductRequest?.id = 0;
      addProductRequest?.local_id = 0;
      title.value = 'add_product'.tr;
      addProductRequest?.qty = 0;
      addProductRequest?.categories = [];

      FilesInfo info = FilesInfo();
      filesList.add(info);
    }

    // FileInfo info1 = FileInfo();
    // info1.file =
    //     "https://fastly.picsum.photos/id/68/536/354.jpg?hmac=1HfgJb31lF-wUi81l2uZsAMfntViiCV9z5_ntQvW3Ks";
    // filesList.add(info1);

    // bool isInternet = await AppUtils.interNetCheck();
    // if (isInternet) {
    //   getProductResourcesApi();
    // } else {
    // if (AppStorage().getProductResources() != null) {
    //   productResourcesResponse.value = AppStorage().getProductResources()!;
    //   isMainViewVisible.value = true;
    // }
    // }
  }

  void setProductDetails(ProductInfo info) {
    // addProductRequest.categories = [];
    // addProductRequest.id = info.id ?? 0;
    // addProductRequest.supplier_id = info.supplierId ?? 0;
    // addProductRequest.lengthUnit_id = info.length_unit_id ?? 0;
    // addProductRequest.weightUnit_id = info.weight_unit_id ?? 0;
    // addProductRequest.manufacturer_id = info.manufacturer_id ?? 0;
    // addProductRequest.model_id = info.model_id ?? 0;

    productTitleController.value.text = info.shortName ?? "";
    productNameController.value.text = info.name ?? "";
    productManufacturerController.value.text = info.manufacturer_name ?? "";
    productPriceController.value.text = info.price ?? "";
    productCutoffController.value.text = info.cutoff ?? "";
    productDescriptionController.value.text = info.description ?? "";
    productSupplierController.value.text = info.supplier_name ?? "";
    productUuidController.value.text = info.uuid ?? "";
    mBarCode = info.barcode_text ?? "";
    productBarcodeController.value.text = info.barcode_text ?? "";
    isStatus.value = info.status ?? false;
    print("UUID:" + info.uuid!);
    print("QTY:${addProductRequest?.qty!}");

    if (!StringHelper.isEmptyList(info.categories)) {
      List<String> ids = [];
      for (int i = 0; i < info.categories!.length; i++) {
        ids.add(info.categories![i].id!.toString());
      }
      if (!StringHelper.isEmptyList(
          productResourcesResponse.value.categories)) {
        for (int i = 0;
            i < productResourcesResponse.value.categories!.length;
            i++) {
          if (ids.contains(
              productResourcesResponse.value.categories![i].id!.toString())) {
            productResourcesResponse.value.categories![i].check = true;
          }
        }
      }
      addProductRequest?.categories = info.categories!;
      productCategoryController.value.text =
          StringHelper.getCommaSeparatedNames(info.categories!);
    } else {
      addProductRequest?.categories = [];
    }

    if (!StringHelper.isEmptyString(info.imageThumbUrl) &&
        info.imageThumbUrl!.startsWith("http")) {
      thumbImage = info.imageThumbUrl ?? "";
      FilesInfo fileInfo = FilesInfo();
      fileInfo.id = 0;
      fileInfo.file = info.imageThumbUrl ?? "";
      fileInfo.fileThumb = info.imageThumbUrl ?? "";
      filesList.add(fileInfo);
    }
    print("thumbImage:" + thumbImage);

    if (info.id != null && info.id! > 0) {
      for (int i = 0; i < info.product_images!.length; i++) {
        ProductImageInfo productImageInfo = info.product_images![i];
        FilesInfo fileInfo = FilesInfo();
        fileInfo.id = productImageInfo.id;
        fileInfo.file = productImageInfo.imageUrl;
        fileInfo.fileThumb = productImageInfo.imageThumbUrl;
        filesList.add(fileInfo);
      }
    } else if (info.local_id != null && info.local_id! > 0) {
      for (int i = 0; i < info.temp_images!.length; i++) {
        if (!StringHelper.isEmptyString(info.temp_images![i].file))
          filesList.add(info.temp_images![i]);
      }
    }
  }

  Future<void> onSubmitClick() async {
    if (formKey.currentState!.validate()) {
      if (isSaveEnable.value) {
        addProductRequest?.shortName =
            productTitleController.value.text.toString().trim();
        addProductRequest?.name =
            productNameController.value.text.toString().trim();
        addProductRequest?.price =
            productPriceController.value.text.toString().trim();
        addProductRequest?.cutoff =
            productCutoffController.value.text.toString().trim();
        addProductRequest?.description =
            productDescriptionController.value.text.toString().trim();
        addProductRequest?.barcode_text =
            productBarcodeController.value.text.toString().trim();
        addProductRequest?.uuid =
            productUuidController.value.text.toString().trim();
        if (addProductRequest?.id != null && addProductRequest?.id != 0) {
          addProductRequest?.mode_type = 2;
        } else {
          addProductRequest?.mode_type = 1;
        }
        addProductRequest?.status = isStatus.value;
        // filesList.removeAt(0);
        addProductRequest?.temp_images = filesList;

        bool isBarcodeAvailable = false;
        if (AppStorage().getStockData() != null) {
          ProductListResponse response = AppStorage().getStockData()!;
          for (int i = 0; i < response.info!.length; i++) {
            ProductInfo item = response.info![i];
            int itemId = item.id ?? 0;
            int id_ = addProductRequest?.id ?? 0;
            int localId_ = addProductRequest?.local_id ?? 0;
            String mBarCode = item.barcode_text ?? "";
            bool currentProduct = itemId == id_ || itemId == localId_;
            if (!currentProduct) {
              String enteredBarCode = addProductRequest?.barcode_text ?? "";
              var listBarcode =
                  StringHelper.getListFromCommaSeparateString(enteredBarCode);
              // if (!StringHelper.isEmptyString(enteredBarCode) &&
              //     mBarCode == enteredBarCode) {
              if (!StringHelper.isEmptyString(enteredBarCode) &&
                  listBarcode.contains(mBarCode)) {
                isBarcodeAvailable = true;
                break;
              }
            }
          }
        }

        if (!isBarcodeAvailable) {
          bool isInternet = await AppUtils.interNetCheck();
          if (isInternet) {
            storeProductApi();
          } else {
            storeProductInList(true, addProductRequest);
          }
        } else {
          AppUtils.showSnackBarMessage('msg_barcode_already_exist'.tr);
        }
      } else {
        Get.back();
      }
    }
  }

  void storeProductInList(bool isOffline, ProductInfo? addProductRequest) {
    print("addProductRequest?.qty${addProductRequest?.qty}");
    List<ProductInfo> listStoredProducts = [];
    if (AppStorage().getStockData() != null) {
      ProductListResponse response = AppStorage().getStockData()!;
      listStoredProducts.addAll(response.info!);
    }

    addProductRequest?.localStored = isOffline;

    if (isOffline && addProductRequest!.temp_images!.length > 1) {
      addProductRequest.imageThumbUrl = addProductRequest.temp_images![1].file;
      addProductRequest.imageUrl = addProductRequest.temp_images![1].file;
    }

    int id = 0, localId = 0;
    if ((addProductRequest?.id != null && addProductRequest?.id! != 0) ||
        (addProductRequest?.local_id != null &&
            addProductRequest?.local_id! != 0)) {
      int index = -1;

      int id_ = addProductRequest?.id ?? 0;
      int localId_ = addProductRequest?.local_id ?? 0;

      for (int i = 0; i < listStoredProducts.length; i++) {
        id = listStoredProducts[i].id ?? 0;
        localId = listStoredProducts[i].local_id ?? 0;
        if ((id_ > 0 && id == id_) || (localId_ > 0 && localId == localId_)) {
          index = i;
          break;
        }
      }

      print("index:" + index.toString());
      if (index != -1) {
        AppUtils.showToastMessage('product_updated_successfully'.tr);
        print("QTY final:${addProductRequest!.qty!}");
        listStoredProducts[index] = addProductRequest!;
      } else {
        AppUtils.showToastMessage('product_added_successfully'.tr);
        int localId = AppStorage().getTempId() + 1;
        print("localId:" + localId.toString());
        addProductRequest?.local_id = localId;
        AppStorage().setTempId(localId);
        listStoredProducts.insert(0, addProductRequest!);
      }
    } else {
      AppUtils.showToastMessage('product_added_successfully'.tr);
      int localId = AppStorage().getTempId() + 1;
      addProductRequest?.local_id = localId;
      AppStorage().setTempId(localId);
      print("addProductRequest?.local_id!:${addProductRequest?.local_id!}");
      listStoredProducts.insert(0, addProductRequest!);
    }
    ProductListResponse response = AppStorage().getStockData()!;
    response.info = listStoredProducts;
    print("listStoredProducts size:" + listStoredProducts.length.toString());
    AppStorage().setStockData(response);
    Get.back(result: true);
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

  void showCategoryList() {
    if (productResourcesResponse.value.categories != null &&
        productResourcesResponse.value.categories!.isNotEmpty) {
      showMultipleSelectionDropDownDialog(
          AppConstants.dialogIdentifier.categoryList,
          'category'.tr,
          productResourcesResponse.value.categories!,
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
          isCloseEnable: true,
          isSearchEnable: true,
        ),
        backgroundColor: Colors.transparent,
        isScrollControlled: true);
  }

  @override
  void onSelectItem(int position, int id, String name, String action) {
    if (action == AppConstants.dialogIdentifier.supplierList) {
      productSupplierController.value.text = name;
      addProductRequest?.supplierId = id;
      addProductRequest?.supplier_name = name;
      onValueChange();
    } else if (action == AppConstants.dialogIdentifier.manufacturerList) {
      productManufacturerController.value.text = name;
      addProductRequest?.manufacturer_id = id;
      onValueChange();
    } else if (action == AppConstants.action.selectImageFromCamera ||
        action == AppConstants.action.selectImageFromGallery) {
      selectImage(action);
    }
  }

  void showMultipleSelectionDropDownDialog(String dialogType, String title,
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
    if (action == AppConstants.dialogIdentifier.categoryList) {
      onValueChange();
      productResourcesResponse.value.categories!.clear();
      productResourcesResponse.value.categories!.addAll(tempList);

      List<ModuleInfo> listSelectedItems = [];
      for (int i = 0; i < tempList.length; i++) {
        if (tempList[i].check ?? false) {
          listSelectedItems.add(tempList[i]);
        }
      }
      if (!StringHelper.isEmptyList(addProductRequest?.categories)) {
        addProductRequest?.categories!.clear();
        addProductRequest?.categories!.addAll(listSelectedItems);
      } else {
        addProductRequest?.categories = [];
        addProductRequest?.categories!.addAll(listSelectedItems);
      }
      productCategoryController.value.text =
          StringHelper.getCommaSeparatedNames(listSelectedItems);
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
    } else {
      ImageUtils.showImagePreviewDialog(filesList[index].file ?? "");
    }
  }

  addPhotoToList(String? path) {
    if (!StringHelper.isEmptyString(path)) {
      isSaveEnable.value = true;
      FilesInfo info = FilesInfo();
      info.file = path;
      filesList.add(info);
      print(filesList.length.toString());
    }
  }

  removePhotoFromList(int index) {
    isSaveEnable.value = true;
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
    map["store_id"] = AppStorage.storeId.toString();
    map["id"] = addProductRequest?.id;
    map["short_name"] = addProductRequest?.shortName;
    map["name"] = addProductRequest?.name;
    map["supplier_id"] = addProductRequest?.supplierId;
    map["supplier_code"] = addProductRequest?.supplier_code;
    map["manufacturer_id"] = addProductRequest?.manufacturer_id;
    map["price"] = addProductRequest?.price;
    map["cutoff"] = addProductRequest?.cutoff;
    map["description"] = addProductRequest?.description;
    // map["status"] = addProductRequest?.status;
    map["status"] = true;
    map["mode_type"] = addProductRequest?.mode_type;
    map["barcode_text"] = addProductRequest?.barcode_text ?? "";
    map["barcodes"] = addProductRequest?.barcode_text ?? "";
    map["uuid"] = addProductRequest?.uuid ?? "";
    map["sort_id"] = addProductRequest?.sort_id ?? "";

    if (!StringHelper.isEmptyList(addProductRequest?.categories)) {
      for (int i = 0; i < addProductRequest!.categories!.length; i++) {
        map['categories[${i.toString()}]'] =
            addProductRequest!.categories![i].id;
      }
    }

    multi.FormData formData = multi.FormData.fromMap(map);

    var list = <FilesInfo>[];
    for (int i = 0; i < filesList.length; i++) {
      if (!StringHelper.isEmptyString(filesList[i].file ?? "") &&
          !filesList[i].file!.startsWith("http")) {
        list.add(filesList[i]);
      }
    }

    if (list.isNotEmpty) {
      int startIndex = 0;
      if (StringHelper.isEmptyString(thumbImage)) startIndex = 1;
      for (int i = startIndex; i < list.length; i++) {
        var info = list[i];
        print("File:" + info.file!);
        formData.files.addAll([
          MapEntry(
              "files[]", await multi.MultipartFile.fromFile(info.file ?? "")),
        ]);
      }
      print("product_file:" + list[0].file!);
      if (StringHelper.isEmptyString(thumbImage)) {
        formData.files.add(
          MapEntry("product_file",
              await multi.MultipartFile.fromFile(list[0].file ?? "")),
        );
      }
    }

    print("Request Data:" + map.toString());
    isLoading.value = true;
    _api.storeProduct(
      formData: formData,
      onSuccess: (ResponseModel responseModel) {
        isLoading.value = false;
        if (responseModel.statusCode == 200) {
          StoreProductResponse response =
              StoreProductResponse.fromJson(jsonDecode(responseModel.result!));
          if (response.IsSuccess!) {
            // getAllStockListApi();
            int localId_ = addProductRequest?.local_id ?? 0;
            if (addProductRequest?.qty != null)
              response.info!.qty = addProductRequest?.qty;
            response.info!.local_id = localId_;
            storeProductInList(false, response.info);
            // moveStockEditQuantityScreen(response.info!.id!.toString());
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

  Future<void> getAllStockListApi() async {
    Map<String, dynamic> map = {};
    map["filters"] = "";
    map["offset"] = 0;
    map["limit"] = AppConstants.productListLimit.toString();
    map["search"] = "";
    map["product_id"] = "0";
    // map["is_stock"] = 1;
    map["store_id"] = AppStorage.storeId.toString();
    map["allData"] = "true";

    multi.FormData formData = multi.FormData.fromMap(map);
    print(map.toString());
    isLoading.value = true;
    StockListRepository().getStockList(
      formData: formData,
      onSuccess: (ResponseModel responseModel) {
        isLoading.value = false;
        if (responseModel.statusCode == 200) {
          ProductListResponse response =
              ProductListResponse.fromJson(jsonDecode(responseModel.result!));
          if (response.IsSuccess!) {
            AppStorage().setStockData(response);
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
        isMainViewVisible.value = true;
        if (error.statusCode == ApiConstants.CODE_NO_INTERNET_CONNECTION) {
          AppUtils.showSnackBarMessage('no_internet'.tr);
        } else if (error.statusMessage!.isNotEmpty) {
          AppUtils.showSnackBarMessage(error.statusMessage!);
        }
      },
    );
  }

  Future<void> openQrCodeScanner() async {
    var code = await Get.toNamed(AppRoutes.qrCodeScannerScreen);
    if (!StringHelper.isEmptyString(code)) {
      mBarCode = code;
      print("mBarCode:" + mBarCode);
      productBarcodeController.value.text = mBarCode;
    }
  }

  Future<void> moveToBarCodeListScreen() async {
    int id_ = addProductRequest?.id ?? 0;
    int localId_ = addProductRequest?.local_id ?? 0;

    var arguments = {
      AppConstants.intentKey.barCode: mBarCode,
      AppConstants.intentKey.productId: id_,
      AppConstants.intentKey.localProductId: localId_,
    };
    var result =
        await Get.toNamed(AppRoutes.barcodeListScreen, arguments: arguments);
    if (!StringHelper.isEmptyString(result)) {
      onValueChange();
      mBarCode = result;
      productBarcodeController.value.text = result;
      print("result" + mBarCode);
    }
  }

  void onValueChange() {
    isSaveEnable.value = true;
  }
}
