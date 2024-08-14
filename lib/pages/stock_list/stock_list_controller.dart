import 'dart:convert';

import 'package:dio/dio.dart' as multi;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/stock_list/stock_list_repository.dart';
import 'package:otm_inventory/utils/app_constants.dart';
import 'package:otm_inventory/utils/app_storage.dart';
import 'package:otm_inventory/utils/string_helper.dart';

import '../../../routes/app_routes.dart';
import '../../../utils/app_utils.dart';
import '../../../web_services/api_constants.dart';
import '../../../web_services/response/response_model.dart';
import '../../utils/AlertDialogHelper.dart';
import '../../utils/date_utils.dart';
import '../../web_services/response/base_response.dart';
import '../../web_services/response/module_info.dart';
import '../common/drop_down_tile_list_dialog.dart';
import '../common/listener/DialogButtonClickListener.dart';
import '../common/listener/select_item_listener.dart';
import '../common/model/file_info.dart';
import '../products/add_product/controller/add_product_repository.dart';
import '../products/add_product/model/store_stock_product_response.dart';
import '../products/product_list/models/last_product_update_time_response.dart';
import '../products/product_list/models/product_info.dart';
import '../products/product_list/models/product_list_response.dart';
import '../stock_edit_quantiry/model/store_stock_request.dart';
import '../stock_filter/controller/stock_filter_repository.dart';
import '../stock_filter/model/filter_request.dart';
import '../stock_filter/model/stock_filter_response.dart';
import '../store_list/model/store_list_response.dart';

class StockListController extends GetxController
    implements DialogButtonClickListener, SelectItemListener {
  final _api = StockListRepository();
  final searchController = TextEditingController().obs;

  // var addProductRequest = AddProductRequest();
  List<ProductInfo> tempList = [];
  final productList = <ProductInfo>[].obs;
  var storeList = <ModuleInfo>[].obs;
  final storeNameController = TextEditingController().obs;
  final isPendingDataCount = false.obs,
      isUpToDateData = false.obs,
      isClearVisible = false.obs;
  final totalPendingCount = 0.obs, mCount = 0.obs;
  final pendingDataCountButtonTitle = "".obs, pullToRefreshTime = "".obs;

  RxBool isLoading = false.obs,
      isInternetNotAvailable = false.obs,
      isMainViewVisible = false.obs,
      isScanQrCode = false.obs,
      isLoadMore = false.obs,
      isUpdateStockButtonVisible = false.obs,
      pullToRefreshVisible = false.obs;

  final filters = ''.obs,
      search = ''.obs,
      mSupplierCategoryFilter = ''.obs,
      downloadTitle = 'download'.tr.obs,
      mTitle = 'stocks'.tr.obs;
  var offset = 0,
      stockCountType = 0,
      mSelectedProductId = 0,
      mSelectedLocalId = 0;
  var mIsLastPage = false;

  // , allStockType = false;
  var mBarCode = "", _title = "";
  late ScrollController controller;

  // var mTitle = 'stocks'.tr.obs;

  @override
  void onInit() async {
    super.onInit();
    AppStorage.storeId = Get.find<AppStorage>().getStoreId();
    AppStorage.storeName = Get.find<AppStorage>().getStoreName();
    if (!StringHelper.isEmptyString(AppStorage.storeName)) {
      storeNameController.value.text = AppStorage.storeName;
    }
    controller = ScrollController();

    var arguments = Get.arguments;
    if (arguments != null) {
      stockCountType = arguments[AppConstants.intentKey.stockCountType] ?? 0;
      // allStockType = arguments[AppConstants.intentKey.allStockType] ?? false;
      _title = arguments[AppConstants.intentKey.title] ?? 'stocks'.tr;
      mCount.value = arguments[AppConstants.intentKey.count] ?? 0;
    } else {
      mCount.value = 0;
      _title = 'stocks'.tr;
    }
    initialDataSet(stockCountType, false);
  }

  initialDataSet(int stockCountType, bool isDrawerClick) {
    searchController.value.clear();
    isClearVisible.value = false;
    if (isDrawerClick) {
      mSupplierCategoryFilter.value = "";
      stockCountType = 0;
      // allStockType = false;
      _title = 'stocks'.tr;
    }
    this.stockCountType = stockCountType;
    if (stockCountType != 0) {
      mSupplierCategoryFilter.value = "-";
      // if (mCount > 0) {
      //   mTitle.value = "${mTitle.value} ($mCount)";
      // }
    } else {
      mSupplierCategoryFilter.value = "";
    }
    setTitle();
    setDownloadTitle();
    setOfflineData();
    onCLickUploadData(false, false, localStockCount(), localProductCount());
  }

  setTitle() {
    mTitle.value = "$_title ($mCount)";
  }

  _scrollListener() {
    if (controller.offset >= controller.position.maxScrollExtent &&
        !controller.position.outOfRange &&
        !mIsLastPage) {
      print("_scrollListener");
      // getStockListApi(false, false, "", false, false);
    }
    if (controller.offset <= controller.position.minScrollExtent &&
        !controller.position.outOfRange) {
      // setState(() {
      //   message = "reach the top";
      // });
    }
  }

  Future<void> searchItem(String value) async {
    print(value);
    List<ProductInfo> results = [];
    if (value.isEmpty) {
      results = tempList;
    } else {
      results = tempList
          .where((element) =>
              (!StringHelper.isEmptyString(element.shortName) &&
                  element.shortName!
                      .toLowerCase()
                      .contains(value.toLowerCase())) ||
              (!StringHelper.isEmptyString(element.name) &&
                  element.name!.toLowerCase().contains(value.toLowerCase())) ||
              (!StringHelper.isEmptyString(element.description) &&
                  element.description!
                      .toLowerCase()
                      .contains(value.toLowerCase())) ||
              (!StringHelper.isEmptyString(element.barcode_text) &&
                  element.barcode_text!
                      .toLowerCase()
                      .contains(value.toLowerCase())) ||
              (listCategories(element.categories!)
                  .contains(value.toLowerCase())))
          .toList();
    }
    productList.value = results;
  }

  List<String> listCategories(List<ModuleInfo>? list) {
    List<String> categoryNames = [];
    if (!StringHelper.isEmptyList(list)) {
      for (var item in list!) {
        categoryNames.add(item.name!.toLowerCase());
      }
    }
    return categoryNames;
  }

  Future<void> openQrCodeScanner() async {
    var code = await Get.toNamed(AppRoutes.qrCodeScannerScreen);
    if (!StringHelper.isEmptyString(code)) {
      mBarCode = code;
      print("mBarCode:" + mBarCode);
      // bool isInternet = await AppUtils.interNetCheck();
      // if (isInternet) {
      //   getStockListApi(true, true, code, true, true);
      // } else {
      int index = -1;
      for (int i = 0; i < productList.length; i++) {
        String mBarcodeText = "";
        var listBarcodes = [];

        if (!StringHelper.isEmptyString(productList[i].barcode_text)) {
          mBarcodeText = productList[i].barcode_text!;
          listBarcodes.addAll(
              StringHelper.getListFromCommaSeparateString(mBarcodeText));
        }
        /*  // if (productList[i].id.toString() == mBarCode ||
        //     mBarcodeText == mBarCode) {*/
        if (productList[i].id.toString() == mBarCode ||
            listBarcodes.contains(mBarCode)) {
          index = i;
          break;
        }
      }

      if (index != -1) {
        moveStockEditQuantityScreenFromQrCode(
            productList[index].id.toString(), productList[index]);
      } else {
        showAddStockProductDialog();
        // AppUtils.showSnackBarMessage('msg_no_qr_code_product_match'.tr);
      }
      // }
    }
  }

  Future<void> moveStockEditQuantityScreenFromQrCode(
      String? productId, ProductInfo? productInfo) async {
    var result;
    if (productId != null) {
      if (productInfo != null) {
        if (productInfo.id != null) mSelectedProductId = productInfo.id!;
        if (productInfo.local_id != null)
          mSelectedLocalId = productInfo.local_id!;
      }
      var arguments = {
        AppConstants.intentKey.productId: productId,
        AppConstants.intentKey.productInfo: productInfo,
      };
      result = await Get.toNamed(AppRoutes.stockEditQuantityScreen,
          arguments: arguments);

      if (!StringHelper.isEmptyString(mBarCode)) {
        mBarCode = "";
        isScanQrCode.value = false;
        openQrCodeScanner();
        // getStockListApi(true, false, "", true, true);
        setOfflineData();
      }
    }
  }

  Future<void> moveStockEditQuantityScreen(
      String? productId, ProductInfo? productInfo) async {
    var result;
    if (productId != null) {
      if (productInfo != null) {
        if (productInfo.id != null) mSelectedProductId = productInfo.id!;
        if (productInfo.local_id != null)
          mSelectedLocalId = productInfo.local_id!;
      }
      var arguments = {
        AppConstants.intentKey.productId: productId,
        AppConstants.intentKey.productInfo: productInfo,
      };
      result = await Get.toNamed(AppRoutes.stockEditQuantityScreen,
          arguments: arguments);
    }

    onCLickUploadData(false, false, localStockCount(), localProductCount());

    if (isScanQrCode.value) {
      mBarCode = "";
      isScanQrCode.value = false;
      openQrCodeScanner();
      // getStockListApi(true, false, "", true, true);
      setOfflineData();
    } else {
      if (result != null && result) {
        /*if (AppStorage().getStockData() != null) {
          ProductListResponse response = AppStorage().getStockData()!;
          tempList.clear();
          tempList.addAll(response.info!);
          productList.value = tempList;
          if (!StringHelper.isEmptyString(searchController.value.text))
            searchItem(searchController.value.text);
          productList.refresh();
        }*/
        setOfflineData();
        setTotalCountButtons();
        isUpdateStockButtonVisible.value =
            !StringHelper.isEmptyList(AppStorage().getStoredStockList());
        // setOfflineData();
      }
    }
  }

  Future<void> stockFilter() async {
    var result = await Get.toNamed(AppRoutes.stockFilterScreen);
    // if (result != null) {
    //   FilterRequest request = result as FilterRequest;
    //   print("supplier:" + request.supplier.toString());
    //   print("category:" + request.category.toString());
    //   print("supplier key:" + request.supplier_key.toString());
    // }
    if (!StringHelper.isEmptyString(result)) {
      print("result:" + result);
      mSupplierCategoryFilter.value = result;
      setOfflineData();
      // getStockListApi(true, false, "", true, false);
    }
  }

  int getSupplierId() {
    int id = 0;
    if (!StringHelper.isEmptyString(mSupplierCategoryFilter.value) &&
        mSupplierCategoryFilter.value != "-") {
      final jsonMap = json.decode(mSupplierCategoryFilter.value);
      List<FilterRequest> list = (jsonMap as List)
          .map((itemWord) => FilterRequest.fromJson(itemWord))
          .toList();
      if (list.isNotEmpty && !StringHelper.isEmptyString(list[0].supplier)) {
        id = int.parse(list[0].supplier!);
      }
    }
    return id;
  }

  int getCategoryId() {
    int id = 0;
    if (!StringHelper.isEmptyString(mSupplierCategoryFilter.value) &&
        mSupplierCategoryFilter.value != "-") {
      final jsonMap = json.decode(mSupplierCategoryFilter.value);
      List<FilterRequest> list = (jsonMap as List)
          .map((itemWord) => FilterRequest.fromJson(itemWord))
          .toList();
      if (list.isNotEmpty && !StringHelper.isEmptyString(list[0].category)) {
        id = int.parse(list[0].category!);
      }
    }
    return id;
  }

  Future<void> addStockProductScreen() async {
    var result;
    if (!StringHelper.isEmptyString(mBarCode)) {
      var arguments = {
        AppConstants.intentKey.barCode: mBarCode,
      };
      result = await Get.toNamed(AppRoutes.addStockProductScreen,
          arguments: arguments);
    }
    openQrCodeScanner();
    if (result != null && result) {
      mBarCode = "";
      isScanQrCode.value = false;
      setOfflineData();
      // getStockListApi(true, false, "", true, true);
    }
  }

  Future<void> addMultipleStockQuantity() async {
    var result;
    result = await Get.toNamed(AppRoutes.stockMultipleQuantityUpdateScreen);
    if (result != null && result) {
      setOfflineData();
    }
  }

  Future<void> onClickSelectButton(int position, ProductInfo info) async {
    /*addProductRequest = AddProductRequest();
    addProductRequest.categories = [];
    addProductRequest.id = info.id ?? 0;
    addProductRequest.supplier_id = info.supplierId ?? 0;
    addProductRequest.lengthUnit_id = info.length_unit_id ?? 0;
    addProductRequest.weightUnit_id = info.weight_unit_id ?? 0;
    addProductRequest.manufacturer_id = info.manufacturer_id ?? 0;
    addProductRequest.model_id = info.model_id ?? 0;
    if (info.categories != null && info.categories!.isNotEmpty) {
      for (int i = 0; i < info.categories!.length; i++) {
        addProductRequest.categories!.add(info.categories![i].id.toString());
      }
    }
    addProductRequest.shortName = info.shortName ?? "";
    addProductRequest.name = info.name ?? "";
    addProductRequest.length = info.length ?? "";
    addProductRequest.width = info.width ?? "";
    addProductRequest.height = info.height ?? "";
    addProductRequest.weight = info.weight ?? "";
    addProductRequest.sku = info.sku ?? "";
    addProductRequest.price = info.price ?? "";
    addProductRequest.tax = info.tax ?? "";
    addProductRequest.description = info.description ?? "";
    addProductRequest.status = info.status ?? false;

    storeProductApi();*/

    bool isInternet = await AppUtils.interNetCheck();

    if (AppStorage().getStockData() != null) {
      ProductListResponse response = AppStorage().getStockData()!;
      for (int i = 0; i < response.info!.length; i++) {
        ProductInfo item = response.info![i];
        var list = StringHelper.getListFromCommaSeparateString(
            item.barcode_text ?? "");
        list.add(mBarCode);
        String newBarcode = StringHelper.getCommaSeparatedStringIds(list);
        if (item.id == info.id) {
          item.barcode_text = newBarcode;
          if (isInternet) {
            AppStorage().setStockData(response);
            storeProductApi(item);
          } else {
            item.mode_type = 2;
            item.localStored = true;
            AppStorage().setStockData(response);
            moveStockEditQuantityScreen(item.id.toString(), item);
          }
          break;
        }
      }
    }
  }

  showAddStockProductDialog() {
    AlertDialogHelper.showAlertDialog(
        "",
        'empty_qr_code_scan_msg'.tr,
        'attach_product'.tr,
        'cancel'.tr,
        AppUtils.isPermission(AppStorage().getPermissions().addProduct)
            ? "add_new_product".tr
            : "",
        true,
        this,
        AppConstants.dialogIdentifier.stockOptionsDialog);
    // AlertDialogHelper.showAlertDialog(
    //     "",
    //     'empty_qr_code_scan_msg'.tr,
    //     "",
    //     'cancel'.tr,
    //     "add_new_product".tr,
    //     true,
    //     this,
    //     AppConstants.dialogIdentifier.stockOptionsDialog);
  }

  @override
  void onNegativeButtonClicked(String dialogIdentifier) {
    Get.back();
  }

  @override
  void onOtherButtonClicked(String dialogIdentifier) {
    if (dialogIdentifier == AppConstants.dialogIdentifier.stockOptionsDialog) {
      Get.back();
      addStockProductScreen();
    }
  }

  @override
  void onPositiveButtonClicked(String dialogIdentifier) {
    if (dialogIdentifier == AppConstants.dialogIdentifier.stockOptionsDialog) {
      isScanQrCode.value = true;
      // getStockListWithCodeApi(true, true, "null");
      Get.back();
      setOfflineData();
    }
  }

  Future<void> getStockListApi(bool isProgress, bool scanQrCode, String? code,
      bool clearOffset, bool clearFilter) async {
    if (clearOffset) {
      offset = 0;
      mIsLastPage = false;
    }
    if (clearFilter) {
      mSupplierCategoryFilter.value = "";
      stockCountType = 0;
      // allStockType = false;
      _title = 'stocks'.tr;
      // mTitle.value = 'stocks'.tr;
    }
    print("clearOffset:" + clearOffset.toString());
    print("clearFilter:" + clearFilter.toString());
    print("stockCountType:" + stockCountType.toString());
    print("mSupplierCategoryFilter.value:" + mSupplierCategoryFilter.value);
    setOfflineData();

    /* isLoadMore.value = offset > 0;
    Map<String, dynamic> map = {};
    map["filters"] = filters.value;
    map["offset"] = offset.toString();
    map["limit"] = AppConstants.productListLimit.toString();
    map["search"] = search;
    map["product_id"] = "0";
    map["is_stock"] = 1;
    map["store_id"] = AppStorage.storeId.toString();
    if (!StringHelper.isEmptyString(mSupplierCategoryFilter.value) &&
        mSupplierCategoryFilter.value != "-") {
      final jsonMap = json.decode(mSupplierCategoryFilter.value);
      List<FilterRequest> list = (jsonMap as List)
          .map((itemWord) => FilterRequest.fromJson(itemWord))
          .toList();
      if (list.isNotEmpty) {
        map["supplier"] = list[0].supplier!;
        map["category"] = list[0].category!;
      }
      // map["supplier_category"] = mSupplierCategoryFilter.value;
    }
    if (scanQrCode) {
      map["barcode_text"] = code;
    }

    multi.FormData formData = multi.FormData.fromMap(map);
    print(map.toString());

    if (isProgress) isLoading.value = true;
    _api.getStockList(
      formData: formData,
      onSuccess: (ResponseModel responseModel) {
        isLoading.value = false;
        isLoadMore.value = false;
        if (responseModel.statusCode == 200) {
          ProductListResponse response =
              ProductListResponse.fromJson(jsonDecode(responseModel.result!));
          if (response.IsSuccess!) {
            if (scanQrCode && response.info!.isEmpty) {
              showAddStockProductDialog();
              // getStockListWithCodeApi(isProgress, true, "null");
            } else {
              isScanQrCode.value = scanQrCode;
              isMainViewVisible.value = true;
              if (scanQrCode) {
                if (response.info!.isNotEmpty) {
                  moveStockEditQuantityScreen(
                      response.info![0].id!.toString(), null);
                }
              } else {
                if (offset == 0) {
                  tempList.clear();
                  tempList.addAll(response.info!);
                  productList.value = tempList;
                  productList.refresh();
                  getAllStockListApi();
                } else if (response.info != null && response.info!.isNotEmpty) {
                  tempList.addAll(response.info!);
                  productList.value = tempList;
                  productList.refresh();
                }

                offset = response.offset!;
                if (offset == 0) {
                  mIsLastPage = true;
                } else {
                  mIsLastPage = false;
                }

                print("tempList size:" + tempList.length.toString());
                print("productList size:" + productList.length.toString());
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
        isMainViewVisible.value = true;
        if (error.statusCode == ApiConstants.CODE_NO_INTERNET_CONNECTION) {
          // AppUtils.showSnackBarMessage('no_internet'.tr);
          setOfflineData();
        } else if (error.statusMessage!.isNotEmpty) {
          AppUtils.showSnackBarMessage(error.statusMessage!);
        }
      },
    );*/
  }

  Future<void> getStockListWithCodeApi(
      bool isProgress, bool scanQrCode, String? code) async {
    Map<String, dynamic> map = {};
    map["filters"] = filters.value;
    map["offset"] = offset.toString();
    map["limit"] = AppConstants.productListLimit.toString();
    map["search"] = search;
    map["product_id"] = "0";
    map["is_stock"] = 1;
    map["store_id"] = AppStorage.storeId.toString();
    if (scanQrCode) {
      map["barcode_text"] = code;
    }

    multi.FormData formData = multi.FormData.fromMap(map);
    print(map.toString());

    if (isProgress) isLoading.value = true;
    _api.getStockList(
      formData: formData,
      onSuccess: (ResponseModel responseModel) {
        isLoading.value = false;
        if (responseModel.statusCode == 200) {
          ProductListResponse response =
              ProductListResponse.fromJson(jsonDecode(responseModel.result!));
          if (response.IsSuccess!) {
            isLoadMore.value = false;
            isScanQrCode.value = scanQrCode;
            tempList.clear();
            tempList.addAll(response.info!);
            productList.value = tempList;
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
        isMainViewVisible.value = true;
        if (error.statusCode == ApiConstants.CODE_NO_INTERNET_CONNECTION) {
          AppUtils.showSnackBarMessage('no_internet'.tr);
        } else if (error.statusMessage!.isNotEmpty) {
          AppUtils.showSnackBarMessage(error.statusMessage!);
        }
      },
    );
  }

  Future<void> getAllStockListApi(bool isProgress, bool isInitialLoad) async {
    isLoadMore.value = offset > 0;
    isLoading.value = isProgress;
    Map<String, dynamic> map = {};
    map["filters"] = "";
    map["offset"] = offset.toString();
    map["limit"] = AppConstants.productListLimit.toString();
    map["search"] = search;
    map["product_id"] = "0";
    map["is_stock"] = 0;
    map["store_id"] = AppStorage.storeId.toString();
    map["allData"] = "true";

    multi.FormData formData = multi.FormData.fromMap(map);
    print(map.toString());

    _api.getStockList(
      formData: formData,
      onSuccess: (ResponseModel responseModel) {
        isLoading.value = false;
        isLoadMore.value = false;
        if (responseModel.statusCode == 200) {
          ProductListResponse response =
              ProductListResponse.fromJson(jsonDecode(responseModel.result!));
          if (response.IsSuccess!) {
            AppStorage().setStockData(response);
            if (isInitialLoad) setOfflineData();
          } else {
            if (isProgress) AppUtils.showSnackBarMessage(response.Message!);
          }
        } else {
          if (isProgress)
            AppUtils.showSnackBarMessage(responseModel.statusMessage!);
        }
      },
      onError: (ResponseModel error) {
        isLoading.value = false;
        isMainViewVisible.value = true;
        // if (error.statusCode == ApiConstants.CODE_NO_INTERNET_CONNECTION) {
        //   AppUtils.showSnackBarMessage('no_internet'.tr);
        // } else if (error.statusMessage!.isNotEmpty) {
        //   AppUtils.showSnackBarMessage(error.statusMessage!);
        // }
      },
    );
  }

  void storeProductApi(ProductInfo info) async {
    Map<String, dynamic> map = {};
    map["id"] = info.id;
    map["barcode_text"] = mBarCode;
    multi.FormData formData = multi.FormData.fromMap(map);
    print("Request Data:" + map.toString());

    isLoading.value = true;

    _api.storeProduct(
      formData: formData,
      onSuccess: (ResponseModel responseModel) {
        isLoading.value = false;
        if (responseModel.statusCode == 200) {
          StoreStockProductResponse response =
              StoreStockProductResponse.fromJson(
                  jsonDecode(responseModel.result!));
          if (response.IsSuccess!) {
            moveStockEditQuantityScreen(info.id.toString(), info);
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

  //For Select Store Dropdown
  void selectStore() {
    if (storeList.isNotEmpty) {
      showStoreListDialog(AppConstants.dialogIdentifier.storeList,
          'select_the_store'.tr, storeList, true, true, true, true, this);
    } else {
      AppUtils.showSnackBarMessage('empty_store_message'.tr);
    }
  }

  void showStoreListDialog(
      String dialogType,
      String title,
      List<ModuleInfo> list,
      bool enableDrag,
      bool isDismiss,
      bool canPop,
      bool isClose,
      SelectItemListener listener) {
    Get.bottomSheet(
        enableDrag: enableDrag,
        isDismissible: isDismiss,
        PopScope(
          canPop: canPop,
          child: DropDownTileListDialog(
            title: title,
            dialogType: dialogType,
            list: list,
            listener: listener,
            isCloseEnable: isClose,
            isSearchEnable: false,
          ),
        ),
        backgroundColor: Colors.transparent,
        isScrollControlled: true);
  }

  @override
  void onSelectItem(int position, int id, String name, String action) {
    if (action == AppConstants.dialogIdentifier.storeList) {
      AppStorage.storeId = id;
      AppStorage.storeName = name;
      storeNameController.value.text = name;
      Get.find<AppStorage>().setStoreId(id);
      Get.find<AppStorage>().setStoreName(name);
      getStockListApi(true, false, "", true, true);
    }
  }

  void getStoreListApi() async {
    Map<String, dynamic> map = {};
    multi.FormData formData = multi.FormData.fromMap(map);
    isLoading.value = true;
    _api.getStoreList(
      formData: formData,
      onSuccess: (ResponseModel responseModel) {
        isLoading.value = false;
        if (responseModel.statusCode == 200) {
          StoreListResponse response =
              StoreListResponse.fromJson(jsonDecode(responseModel.result!));
          if (response.IsSuccess!) {
            if (response.info != null && response.info!.isNotEmpty) {
              storeList.clear();
              for (int i = 0; i < response.info!.length; i++) {
                ModuleInfo info = ModuleInfo();
                info.id = response.info![i].id;
                info.name = response.info![i].storeName!;
                storeList.add(info);
              }
            }
            if (AppStorage.storeId == 0 && storeList.isNotEmpty) {
              showStoreListDialog(
                  AppConstants.dialogIdentifier.storeList,
                  'select_the_store'.tr,
                  storeList,
                  false,
                  false,
                  false,
                  false,
                  this);
            } else {
              getStockListApi(true, false, "", true, true);
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
        isMainViewVisible.value = true;
        if (error.statusCode == ApiConstants.CODE_NO_INTERNET_CONNECTION) {
          // AppUtils.showSnackBarMessage('no_internet'.tr);
          setOfflineData();
        } else if (error.statusMessage!.isNotEmpty) {
          AppUtils.showSnackBarMessage(error.statusMessage!);
        }
      },
    );
  }

  // Future<void> onClickUploadStockButton() async {
  //   bool isInternet = await AppUtils.interNetCheck();
  //   if (isInternet) {
  //     List<StockStoreRequest> list = AppStorage().getStoredStockList();
  //     print(jsonEncode("Local List:" + jsonEncode(list)));
  //     storeLocalStocksAPI(true, jsonEncode(list));
  //   } else {
  //     AppUtils.showSnackBarMessage('no_internet'.tr);
  //   }
  // }

  // Future<void> storeLocalStocks(bool isProgress, String data) async {
  //   Map<String, dynamic> map = {};
  //   map["app_data"] = data;
  //   multi.FormData formData = multi.FormData.fromMap(map);
  //   print(map.toString());
  //   if (isProgress) isLoading.value = true;
  //   _api.storeLocalStock(
  //     formData: formData,
  //     onSuccess: (ResponseModel responseModel) {
  //       isLoading.value = false;
  //       if (responseModel.statusCode == 200) {
  //         BaseResponse response =
  //             BaseResponse.fromJson(jsonDecode(responseModel.result!));
  //         if (response.IsSuccess!) {
  //           if (!StringHelper.isEmptyString(response.Message)) {
  //             AppUtils.showSnackBarMessage(response.Message ?? "");
  //           }
  //           AppStorage().clearStoredStockList();
  //           isUpdateStockButtonVisible.value =
  //               !StringHelper.isEmptyList(AppStorage().getStoredStockList());
  //           getStockListApi(true, false, "", true, true);
  //         } else {
  //           AppUtils.showSnackBarMessage(response.Message!);
  //         }
  //       } else {
  //         AppUtils.showSnackBarMessage(responseModel.statusMessage!);
  //       }
  //     },
  //     onError: (ResponseModel error) {
  //       isLoading.value = false;
  //       isMainViewVisible.value = true;
  //       if (error.statusCode == ApiConstants.CODE_NO_INTERNET_CONNECTION) {
  //         AppUtils.showSnackBarMessage('no_internet'.tr);
  //       } else if (error.statusMessage!.isNotEmpty) {
  //         AppUtils.showSnackBarMessage(error.statusMessage!);
  //       }
  //     },
  //   );
  // }

  void setOfflineData() {
    isMainViewVisible.value = true;
    if (AppStorage().getStockData() != null) {
      ProductListResponse response = AppStorage().getStockData()!;
      tempList.clear();
      if (stockCountType == 0) {
        if (!StringHelper.isEmptyString(mSupplierCategoryFilter.value) &&
            mSupplierCategoryFilter.value != "-") {
          final jsonMap = json.decode(mSupplierCategoryFilter.value);
          FilterRequest filterRequest = FilterRequest.fromJson(jsonMap);
          String categoryName = filterRequest.category_name ?? "";
          _title = categoryName;
          setFilterList(filterRequest, response.info!);
        } else {
          tempList.addAll(response.info!);
        }
      } else {
        for (var info in response.info!) {
          if (stockCountType == 1 || stockCountType == 2) {
            if (info.stock_status_id == 1 || info.stock_status_id == 2) {
              tempList.add(info);
            }
          } else if (info.stock_status_id == stockCountType) {
            tempList.add(info);
          }
        }
      }

      print("stockCountType:" + stockCountType.toString());
      print("mSupplierCategoryFilter.value:" + mSupplierCategoryFilter.value);

      List<ProductInfo> list = [];

      for (int i = 0; i < tempList.length; i++) {
        ProductInfo info = tempList[i];
        if (isStoreMatch(
            info.product_stocks, info.temp_store_id ?? 0, info.qty ?? 0)) {
          list.add(info);
        }
      }

      productList.value = list;
      productList.refresh();
      print("tempList size:" + tempList.length.toString());
      print("productList size:" + productList.length.toString());
    }
    mCount.value = productList.length;
    setTitle();
    // onCLickUploadData(false, localStockCount(), localProductCount());
    setTotalCountButtons();
    isUpdateStockButtonVisible.value =
        !StringHelper.isEmptyList(AppStorage().getStoredStockList());
  }

  bool isStoreMatch(List<ProductStockInfo>? list, int tempStoreId, int qty) {
    bool match = false;

    if (tempStoreId == AppStorage.storeId) {
      match = true;
    } else if (list != null && list.isNotEmpty) {
      for (var info in list) {
        int storeId = info.store_id ?? 0;
        if (storeId == AppStorage.storeId) {
          match = true;
          break;
        }
      }
    }
    return match;
  }

  void setFilterList(FilterRequest filterRequest, List<ProductInfo>? list) {
    int supplierId = !StringHelper.isEmptyString(filterRequest.supplier)
        ? int.parse(filterRequest.supplier!)
        : 0;
    String supplierKey = !StringHelper.isEmptyString(filterRequest.supplier_key)
        ? filterRequest.supplier_key!
        : "";
    int categoryId = !StringHelper.isEmptyString(filterRequest.category)
        ? int.parse(filterRequest.category!)
        : 0;
    String categoryName = filterRequest.category_name ?? "";
    String categoryKey = filterRequest.category_key ?? "";

    print("supplier:" + supplierId.toString());
    print("supplier key:" + supplierKey.toString());
    print("category:" + categoryId.toString());
    print("categoryName:" + categoryName);
    print("categoryKey:" + categoryKey);
    for (var element in list!) {
      print("-----------------------------");
      List<String> categoryIds = [];
      for (var categoryInfo in element.categories!) {
        categoryIds.add(categoryInfo.id!.toString());
      }

      if (supplierKey == 'all_category') {
        if (categoryId != 0) {
          if (categoryIds.contains(categoryId.toString())) {
            tempList.add(element);
          }
        } else {
          tempList.addAll(list);
        }
      } else if (supplierKey == 'no_supplier_category') {
        if (categoryId != 0) {
          if ((element.supplierId == null || element.supplierId! == 0) &&
              categoryIds.contains(categoryId.toString())) {
            tempList.add(element);
          }
        } else {
          if ((element.supplierId == null || element.supplierId! == 0)) {
            tempList.add(element);
          }
        }
      } else if (supplierKey == 'status') {
        if (categoryKey == 'in_stock') {
          if (element.stock_status_id == 1 || element.stock_status_id == 2) {
            tempList.add(element);
          }
        } else if (categoryKey == 'out_of_stock') {
          if (element.stock_status_id == 3) {
            tempList.add(element);
          }
        } else if (categoryKey == 'minus_stock') {
          if (element.stock_status_id == 4) {
            tempList.add(element);
          }
        } else {
          tempList.add(element);
        }
      } else if (supplierId != 0 && categoryId != 0) {
        if ((element.supplierId != null && element.supplierId! == supplierId) &&
            categoryIds.contains(categoryId.toString())) {
          tempList.add(element);
        }
      } else if (supplierId != 0 && categoryId != 0) {
        if ((element.supplierId != null && element.supplierId! == supplierId) &&
            categoryIds.contains(categoryId.toString())) {
          tempList.add(element);
        }
      } else if (supplierId != 0 && categoryId == 0) {
        if ((element.supplierId != null && element.supplierId! == supplierId)) {
          tempList.add(element);
        }
      } else {
        tempList.addAll(list);
      }

      // if (supplierId != 0 && categoryId != 0) {
      //   if ((element.supplierId != null && element.supplierId! == supplierId) &&
      //       categoryIds.contains(categoryId.toString())) {
      //     tempList.add(element);
      //   }
      // } else if (supplierId != 0 && categoryId == 0) {
      //   if (element.supplierId != null && element.supplierId! == supplierId) {
      //     tempList.add(element);
      //   }
      // } else if (supplierId == 0 && categoryId != 0) {
      //   if (categoryIds.contains(categoryId.toString())) {
      //     tempList.add(element);
      //   }
      // } else {
      //   tempList.addAll(list);
      // }
    }
  }

  void setDownloadTitle() {
    if (!StringHelper.isEmptyString(AppStorage().getStockSize())) {
      downloadTitle.value = "${'download'.tr} (${AppStorage().getStockSize()})";
    } else {
      downloadTitle.value = 'download'.tr;
    }
  }

  int localStockCount() {
    List<StockStoreRequest> list = AppStorage().getStoredStockList();
    return list.length;
  }

  int localProductCount() {
    int count = 0;
    if (AppStorage().getStockData() != null) {
      ProductListResponse response = AppStorage().getStockData()!;
      if (response.info!.isNotEmpty) {
        List<ProductInfo> list = [];
        for (int i = 0; i < response.info!.length; i++) {
          bool isLocalStored = response.info![i].localStored ?? false;
          if (isLocalStored) {
            list.add(response.info![i]);
          }
        }
        count = list.length;
      }
    }
    return count;
  }

  void setTotalCountButtons() {
    int stockCount = localStockCount();
    int productCount = localProductCount();
    totalPendingCount.value = stockCount + productCount;

    if (totalPendingCount.value > 0) {
      pendingDataCountButtonTitle.value =
          "$totalPendingCount.value Changes Pending";
      isPendingDataCount.value = true;
      isUpToDateData.value = false;
    } else {
      isPendingDataCount.value = false;
      isUpToDateData.value = true;
    }
  }

  Future<void> onCLickUploadData(
      bool isProgress, bool isInitial, int stockCount, int productCount) async {
    bool isInternet = await AppUtils.interNetCheck();
    if (isInternet) {
      getLastProductUpdateTimeAPI(false);
      getFiltersListApi();
      if (stockCount > 0) {
        List<StockStoreRequest> list = AppStorage().getStoredStockList();
        storeLocalStocksAPI(
            isProgress, jsonEncode(list), productCount, isInitial);
      } else if (productCount > 0) {
        storeLocalProducts(isProgress, getLocalStoredProduct(), isInitial);
      } else {
        getAllStockListApi(isProgress, isInitial);
      }
    } else {
      if (isProgress) AppUtils.showSnackBarMessage('no_internet'.tr);
    }
  }

  Future<void> storeLocalStocksAPI(
      bool isProgress, String data, int productCount, bool isInitial) async {
    Map<String, dynamic> map = {};
    map["store_id"] = AppStorage.storeId.toString();
    map["app_data"] = data;
    multi.FormData formData = multi.FormData.fromMap(map);
    print(map.toString());
    if (isProgress) isLoading.value = true;
    StockListRepository().storeLocalStock(
      formData: formData,
      onSuccess: (ResponseModel responseModel) {
        isLoading.value = false;
        if (responseModel.statusCode == 200) {
          BaseResponse response =
              BaseResponse.fromJson(jsonDecode(responseModel.result!));
          if (response.IsSuccess!) {
            if (productCount > 0) {
              storeLocalProducts(
                  isProgress, getLocalStoredProduct(), isInitial);
            } else {
              if (isProgress)
                AppUtils.showSnackBarMessage('msg_stock_data_uploaded'.tr);
              AppStorage().clearStoredStockList();
              setTotalCountButtons();
              getAllStockListApi(false, isInitial);
              // setOfflineData();
            }
          } else {
            // AppUtils.showSnackBarMessage(response.Message!);
          }
        } else {
          // AppUtils.showSnackBarMessage(responseModel.statusMessage!);
        }
      },
      onError: (ResponseModel error) {
        isLoading.value = false;
        isMainViewVisible.value = true;
        // if (error.statusCode == ApiConstants.CODE_NO_INTERNET_CONNECTION) {
        //   AppUtils.showSnackBarMessage('no_internet'.tr);
        // } else if (error.statusMessage!.isNotEmpty) {
        //   AppUtils.showSnackBarMessage(error.statusMessage!);
        // }
      },
    );
  }

  Future<void> storeLocalProducts(
      bool isProgress, List<ProductInfo> listProducts, bool isInitial) async {
    Map<String, dynamic> map = {};
    map["store_id"] = AppStorage.storeId.toString();
    map["data"] = jsonEncode(listProducts);
    multi.FormData formData = multi.FormData.fromMap(map);
    for (int i = 0; i < listProducts.length; i++) {
      var listFiles = <FilesInfo>[];
      if (!StringHelper.isEmptyList(listProducts[i].temp_images)) {
        for (int j = 0; j < listProducts[i].temp_images!.length; j++) {
          if (!StringHelper.isEmptyString(
                  listProducts[i].temp_images![j].file ?? "") &&
              !listProducts[i].temp_images![j].file!.startsWith("http")) {
            listFiles.add(listProducts[i].temp_images![j]);
          }
        }
      }
      if (listFiles.isNotEmpty) {
        for (var info in listFiles) {
          formData.files.addAll([
            MapEntry("files[$i][]",
                await multi.MultipartFile.fromFile(info.file ?? "")),
          ]);
        }
      }
    }

    print(map.toString());
    if (isProgress) isLoading.value = true;
    AddProductRepository().storeMultipleProduct(
      formData: formData,
      onSuccess: (ResponseModel responseModel) {
        isLoading.value = false;
        if (responseModel.statusCode == 200) {
          BaseResponse response =
              BaseResponse.fromJson(jsonDecode(responseModel.result!));
          if (response.IsSuccess!) {
            if (isProgress)
              AppUtils.showSnackBarMessage('msg_stock_data_uploaded'.tr);
            AppStorage().clearStoredStockList();
            setTotalCountButtons();
            getAllStockListApi(false, false);
            // setOfflineData();
          } else {
            // AppUtils.showSnackBarMessage(response.Message!);
          }
        } else {
          // AppUtils.showSnackBarMessage(responseModel.statusMessage!);
        }
      },
      onError: (ResponseModel error) {
        isLoading.value = false;
        isMainViewVisible.value = true;
        // if (error.statusCode == ApiConstants.CODE_NO_INTERNET_CONNECTION) {
        //   AppUtils.showSnackBarMessage('no_internet'.tr);
        // } else if (error.statusMessage!.isNotEmpty) {
        //   AppUtils.showSnackBarMessage(error.statusMessage!);
        // }
      },
    );
  }

  Future<void> getLastProductUpdateTimeAPI(bool isProgress) async {
    Map<String, dynamic> map = {};
    map["store_id"] = AppStorage.storeId.toString();
    multi.FormData formData = multi.FormData.fromMap(map);
    print(map.toString());
    if (isProgress) isLoading.value = true;
    _api.getLastProductUpdateTime(
      formData: formData,
      onSuccess: (ResponseModel responseModel) {
        isLoading.value = false;
        if (responseModel.statusCode == 200) {
          LastProductUpdateTimeResponse response =
              LastProductUpdateTimeResponse.fromJson(
                  jsonDecode(responseModel.result!));
          if (response.IsSuccess!) {
            String responseTime = response.created_at ?? "";
            // if (!StringHelper.isEmptyString(responseTime)) {
            //   pullToRefreshTime.value = responseTime;
            //   pullToRefreshVisible.value = true;
            // }
            if (!StringHelper.isEmptyString(responseTime)) {
              String lastTime = AppStorage().getLastUpdateTime();
              print("lastTime:" + lastTime);
              print("responseTime:" + responseTime);
              if (!StringHelper.isEmptyString(lastTime)) {
                DateTime? lastDateTime = DateUtil.stringToDate(
                    lastTime, DateUtil.DD_MM_YYYY_TIME_24_SLASH);
                DateTime? responseDateTime = DateUtil.stringToDate(
                    responseTime, DateUtil.DD_MM_YYYY_TIME_24_SLASH);
                if (responseDateTime!.isAfter(lastDateTime!)) {
                  pullToRefreshTime.value = lastTime;
                  pullToRefreshVisible.value = true;
                }
                print("pullToRefreshVisible.value:" +
                    pullToRefreshVisible.value.toString());
              } else {
                pullToRefreshTime.value = lastTime;
                pullToRefreshVisible.value = true;
              }
              AppStorage().setLastUpdateTime(response.created_at!);
            }
          } else {
            // AppUtils.showSnackBarMessage(response.Message!);
          }
        } else {
          // AppUtils.showSnackBarMessage(responseModel.statusMessage!);
        }
      },
      onError: (ResponseModel error) {
        isLoading.value = false;
        // if (error.statusCode == ApiConstants.CODE_NO_INTERNET_CONNECTION) {
        //   AppUtils.showSnackBarMessage('no_internet'.tr);
        // } else if (error.statusMessage!.isNotEmpty) {
        //   AppUtils.showSnackBarMessage(error.statusMessage!);
        // }
      },
    );
  }

  void getFiltersListApi() async {
    Map<String, dynamic> map = {};
    multi.FormData formData = multi.FormData.fromMap(map);
    // isLoading.value = true;
    StockFilterRepository().getStockFiltersList(
      formData: formData,
      onSuccess: (ResponseModel responseModel) {
        isLoading.value = false;
        if (responseModel.statusCode == 200) {
          StockFilterResponse response =
              StockFilterResponse.fromJson(jsonDecode(responseModel.result!));
          if (response.isSuccess!) {
            AppStorage().setStockFiltersData(response);
          } else {
            AppUtils.showSnackBarMessage(response.message!);
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

  List<ProductInfo> getLocalStoredProduct() {
    List<ProductInfo> listProducts = [];
    if (AppStorage().getStockData() != null) {
      ProductListResponse response = AppStorage().getStockData()!;
      if (response.info!.isNotEmpty) {
        for (int i = 0; i < response.info!.length; i++) {
          bool isLocalStored = response.info![i].localStored ?? false;
          if (isLocalStored) {
            listProducts.add(response.info![i]);
          }
        }
      }
    }
    return listProducts;
  }
}
