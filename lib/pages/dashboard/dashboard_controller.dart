import 'dart:convert';

import 'package:dio/dio.dart' as multi;
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/dashboard/dashboard_repository.dart';
import 'package:otm_inventory/pages/dashboard/models/dashboard_stock_count_response.dart';
import 'package:otm_inventory/pages/dashboard/tabs/home_tab/home_tab.dart';
import 'package:otm_inventory/pages/dashboard/tabs/more_tab/more_tab.dart';
import 'package:otm_inventory/pages/products/product_list/models/product_info.dart';
import 'package:otm_inventory/routes/app_routes.dart';
import 'package:otm_inventory/utils/string_helper.dart';

import '../../utils/app_constants.dart';
import '../../utils/app_storage.dart';
import '../../utils/app_utils.dart';
import '../../utils/data_utils.dart';
import '../../web_services/api_constants.dart';
import '../../web_services/response/base_response.dart';
import '../../web_services/response/module_info.dart';
import '../../web_services/response/response_model.dart';
import '../add_store/model/store_resources_response.dart';
import '../common/drop_down_list_dialog.dart';
import '../common/listener/select_item_listener.dart';
import '../common/model/file_info.dart';
import '../products/add_product/controller/add_product_repository.dart';
import '../products/add_product/model/product_resources_response.dart';
import '../products/product_list/models/product_list_response.dart';
import '../stock_edit_quantiry/model/store_stock_request.dart';
import '../stock_edit_quantiry/stock_edit_quantity_repository.dart';
import '../stock_list/stock_list_controller.dart';
import '../stock_list/stock_list_repository.dart';
import '../store_list/model/store_list_response.dart';
import 'models/DashboardActionItemInfo.dart';

class DashboardController extends GetxController
    with GetSingleTickerProviderStateMixin
    implements SelectItemListener {
  final _api = DashboardRepository();
  var storeList = <ModuleInfo>[].obs;
  final storeNameController = TextEditingController().obs;
  final List<List<DashboardActionItemInfo>> listHeaderButtons_ =
      DataUtils.generateChunks(DataUtils.getHeaderActionButtonsList(), 3).obs;
  final List<DashboardActionItemInfo> listHeaderButtons =
      DataUtils.getHeaderActionButtonsList().obs;
  RxBool isLoading = false.obs,
      isInternetNotAvailable = false.obs,
      isMainViewVisible = false.obs;
  final title = 'dashboard'.tr.obs, downloadTitle = 'download'.tr.obs;
  final selectedIndex = 0.obs,
      mInStockCount = 0.obs,
      mLowStockCount = 0.obs,
      mOutOfStockCount = 0.obs,
      mMinusStockCount = 0.obs;

  // final pageController = PageController();
  late final PageController pageController;
  final tabs = <Widget>[
    // StockListScreen(),
    HomeTab(),
    // ProfileTab(),
    MoreTab(),
  ];

  @override
  Future<void> onInit() async {
    super.onInit();

    var arguments = Get.arguments;
    if (arguments != null) {
      selectedIndex.value = arguments[AppConstants.intentKey.dashboardTabIndex];
    }
    pageController = PageController(initialPage: selectedIndex.value);
    setTitle(selectedIndex.value);

    AppStorage.storeId = Get.find<AppStorage>().getStoreId();
    AppStorage.storeName = Get.find<AppStorage>().getStoreName();
    if (!StringHelper.isEmptyString(AppStorage.storeName)) {
      storeNameController.value.text = AppStorage.storeName;
      setDashboardData();
    } else {
      getStoreListApi();
    }
    // else {
    //   isMainViewVisible.value = true;
    //   setHeaderListArray();
    // }

    // isMainViewVisible.value = true;
    // setHeaderListArray();
  }

  Future<void> setDashboardData() async {
    bool isInternet = await AppUtils.interNetCheck();
    print("isInternet:" + isInternet.toString());
    if (isInternet) {
      getDashboardStockCountApi(true);
    } else {
      isMainViewVisible.value = true;
      if (AppStorage().getDashboardStockCountData() != null) {
        DashboardStockCountResponse response =
            AppStorage().getDashboardStockCountData()!;
        setItemCount(response);
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  void onPageChanged(int index) {
    selectedIndex.value = index;
    print("selectedIndex.value:${selectedIndex.value}");
    setTitle(index);
  }

  void setTitle(int index) {
    if (index == 0) {
      title.value = 'dashboard'.tr;
    }
    // else if (index == 1) {
    //   title.value = 'profile'.tr;
    // }
    else if (index == 1) {
      title.value = 'more'.tr;
    }
  }

  void onItemTapped(int index) {
    // if (index == 1) {
    //   Navigator.push(
    //     context,
    //     MaterialPageRoute(builder: (context) => ScannerScreen()),
    //   );
    // } else {
    pageController.jumpToPage(index);
    // }
  }

  //Home Tab
  final selectedActionButtonPagerPosition = 0.obs;
  final dashboardActionButtonsController = PageController(
    initialPage: 0,
  );

  void onActionButtonClick(String action) {
    if (action == AppConstants.action.items) {
      Get.offNamed(AppRoutes.productListScreen);
    } else if (action == AppConstants.action.store) {
      Get.offNamed(AppRoutes.storeListScreen);
    } else if (action == AppConstants.action.stocks) {
      Get.offNamed(AppRoutes.stockListScreen);
    } else if (action == AppConstants.action.suppliers) {
      Get.offNamed(AppRoutes.supplierListScreen);
    } else if (action == AppConstants.action.categories) {
      Get.offNamed(AppRoutes.categoryListScreen);
    }
  }

  void selectStore() {
    if (storeList.isNotEmpty) {
      showStoreListDialog(AppConstants.dialogIdentifier.storeList, 'stores'.tr,
          storeList, true, true, true, true, this);
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
          child: DropDownListDialog(
              title: title,
              dialogType: dialogType,
              list: list,
              listener: listener,
              isCloseEnable: isClose),
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
      setHeaderListArray();
      setDashboardData();
    }
  }

  Future<void> addMultipleStockQuantity() async {
    var result;
    result = await Get.toNamed(AppRoutes.stockMultipleQuantityUpdateScreen);
    if (result != null && result) {
      Get.put(StockListController())
          .getStockListApi(true, false, "", true, true);
    }
  }

  Future<void> onClickStockItem(int stockCountType) async {
    var arguments = {
      AppConstants.intentKey.stockCountType: stockCountType,
    };
    Get.toNamed(AppRoutes.stockListScreen, arguments: arguments);
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
            isMainViewVisible.value = true;
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
              showStoreListDialog(AppConstants.dialogIdentifier.storeList,
                  'stores'.tr, storeList, false, false, false, false, this);
            } else {
              setHeaderListArray();
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
          AppUtils.showSnackBarMessage('no_internet'.tr);
        } else if (error.statusMessage!.isNotEmpty) {
          AppUtils.showSnackBarMessage(error.statusMessage!);
        }
      },
    );
  }

  void getDashboardStockCountApi(bool isProgress) async {
    Map<String, dynamic> map = {};
    map["store_id"] = AppStorage.storeId.toString();
    multi.FormData formData = multi.FormData.fromMap(map);
    isLoading.value = isProgress;
    _api.getDashboardStockCountResponse(
      formData: formData,
      onSuccess: (ResponseModel responseModel) {
        isLoading.value = false;
        if (responseModel.statusCode == 200) {
          DashboardStockCountResponse response =
              DashboardStockCountResponse.fromJson(
                  jsonDecode(responseModel.result!));
          if (response.isSuccess!) {
            isMainViewVisible.value = true;
            AppStorage().setDashboardStockCountData(response);
            AppStorage().setStockSize(response.data_size ?? "");
            setItemCount(response);
            storeStockData(false);
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

  void setItemCount(DashboardStockCountResponse? response) {
    if (response != null) {
      mInStockCount.value = response.inStockCount ?? 0;
      mLowStockCount.value = response.lowStockCount ?? 0;
      mOutOfStockCount.value = response.outOfStockCount ?? 0;
      mMinusStockCount.value = response.minusStockCount ?? 0;

      if (!StringHelper.isEmptyString(response.data_size)) {
        downloadTitle.value = "${'download'.tr} (${response.data_size!})";
      } else {
        downloadTitle.value = 'download'.tr;
      }
    }
  }

  void getStoreResourcesApi() async {
    Map<String, dynamic> map = {};
    multi.FormData formData = multi.FormData.fromMap(map);
    // isLoading.value = isProgress;

    StockEditQuantityRepository().getStoreResources(
      formData: formData,
      onSuccess: (ResponseModel responseModel) {
        isLoading.value = false;
        if (responseModel.statusCode == 200) {
          StoreResourcesResponse response = StoreResourcesResponse.fromJson(
              jsonDecode(responseModel.result!));
          if (response.IsSuccess!) {
            AppStorage().setStockResources(response);
            AppConstants.isResourcesLoaded = true;
          } else {
            // AppUtils.showSnackBarMessage(response.Message!);
          }
        } else {
          // AppUtils.showSnackBarMessage(responseModel.statusMessage!);
        }
      },
      onError: (ResponseModel error) {
        isLoading.value = false;
        // isMainViewVisible.value = true;
        // if (error.statusCode == ApiConstants.CODE_NO_INTERNET_CONNECTION) {
        //   AppUtils.showSnackBarMessage('no_internet'.tr);
        // } else if (error.statusMessage!.isNotEmpty) {
        //   AppUtils.showSnackBarMessage(error.statusMessage!);
        // }
      },
    );
  }

  Future<void> getAllStockListApi(bool isProgress) async {
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
    isLoading.value = isProgress;
    StockListRepository().getStockList(
      formData: formData,
      onSuccess: (ResponseModel responseModel) {
        isLoading.value = false;
        if (responseModel.statusCode == 200) {
          ProductListResponse response =
              ProductListResponse.fromJson(jsonDecode(responseModel.result!));
          if (response.IsSuccess!) {
            AppStorage().setStockData(response);
            if (!AppConstants.isResourcesLoaded) {
              loadAllImages();
              getStoreResourcesApi();
              getProductResourcesApi();
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

  void getProductResourcesApi() async {
    Map<String, dynamic> map = {};
    multi.FormData formData = multi.FormData.fromMap(map);
    // isLoading.value = true;

    AddProductRepository().getProductResources(
      formData: formData,
      onSuccess: (ResponseModel responseModel) {
        // isLoading.value = false;
        if (responseModel.statusCode == 200) {
          ProductResourcesResponse response = ProductResourcesResponse.fromJson(
              jsonDecode(responseModel.result!));
          if (response.IsSuccess!) {
            // AppUtils.showSnackBarMessage('msg_stock_data_downloaded'.tr);
            AppStorage().setProductResources(response);
          } else {
            // AppUtils.showSnackBarMessage(response.Message!);
          }
        } else {
          // AppUtils.showSnackBarMessage(responseModel.statusMessage!);
        }
      },
      onError: (ResponseModel error) {
        isLoading.value = false;
        // isMainViewVisible.value = true;
        // if (error.statusCode == ApiConstants.CODE_NO_INTERNET_CONNECTION) {
        //   AppUtils.showSnackBarMessage('no_internet'.tr);
        // } else if (error.statusMessage!.isNotEmpty) {
        //   AppUtils.showSnackBarMessage(error.statusMessage!);
        // }
      },
    );
  }

  Future<void> storeLocalStocksAPI(bool isProgress, String data) async {
    Map<String, dynamic> map = {};
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
            if (isLocalProductsAvailable()) {
              storeLocalProducts(isProgress, getLocalStoredProduct());
            } else {
              if (isProgress)
                AppUtils.showSnackBarMessage('msg_stock_data_uploaded'.tr);
              AppStorage().clearStoredStockList();
              getAllStockListApi(isProgress);
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
      bool isProgress, List<ProductInfo> listProducts) async {
    Map<String, dynamic> map = {};
    map["data"] = jsonEncode(listProducts);
    multi.FormData formData = multi.FormData.fromMap(map);
    for (int i = 0; i < listProducts.length; i++) {
      var listFiles = <FilesInfo>[];
      for (int j = 0; j < listProducts[i].temp_images!.length; j++) {
        if (!StringHelper.isEmptyString(
                listProducts[i].temp_images![j].file ?? "") &&
            !listProducts[i].temp_images![j].file!.startsWith("http")) {
          listFiles.add(listProducts[i].temp_images![j]);
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
            getAllStockListApi(true);
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

  void loadAllImages() {
    if (AppStorage().getStockData() != null) {
      ProductListResponse response = AppStorage().getStockData()!;
      if (response.info!.isNotEmpty) {
        for (int i = 0; i < response.info!.length; i++) {
          if (response.info![i].imageThumbUrl != null &&
              !StringHelper.isEmptyString(response.info![i].imageThumbUrl)) {
            DefaultCacheManager()
                .downloadFile(response.info![i].imageThumbUrl!)
                .then((_) {});
          }
        }
      }
    }
    var userInfo = Get.find<AppStorage>().getUserInfo();
    if (!StringHelper.isEmptyString(userInfo.image)) {
      DefaultCacheManager().downloadFile(userInfo.image!).then((_) {});
    }
  }

  void setHeaderListArray() {
    listHeaderButtons_.clear();
    listHeaderButtons_.addAll(
        DataUtils.generateChunks(DataUtils.getHeaderActionButtonsList(), 3)
            .obs);
    listHeaderButtons.clear();
    listHeaderButtons.addAll(DataUtils.getHeaderActionButtonsList());
  }

  void logoutAPI() async {
    String deviceModelName = await AppUtils.getDeviceName();
    Map<String, dynamic> map = {};
    map["model_name"] = deviceModelName;
    map["is_inventory"] = "true";
    multi.FormData formData = multi.FormData.fromMap(map);
    print("request parameter:" + map.toString());
    isLoading.value = true;
    _api.logout(
      formData: formData,
      onSuccess: (ResponseModel responseModel) {
        if (responseModel.statusCode == 200) {
          Get.find<AppStorage>().clearAllData();
          Get.offAllNamed(AppRoutes.loginScreen);
        } else {
          AppUtils.showSnackBarMessage(responseModel.statusMessage!);
        }
        isLoading.value = false;
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

  Future<void> stockFilter() async {
    // if (info != null) {
    //   var arguments = {
    //     AppConstants.intentKey.storeInfo: info,
    //   };
    //   result =
    //   await Get.toNamed(AppRoutes.addStoreScreen, arguments: arguments);
    // } else {
    //   result = await Get.toNamed(AppRoutes.stockFilterScreen);
    // }

    var result = await Get.toNamed(AppRoutes.stockFilterScreen);
    if (!StringHelper.isEmptyString(result)) {
      print("result" + result);
      Get.put(StockListController()).mSupplierCategoryFilter.value = result;
      Get.put(StockListController())
          .getStockListApi(true, false, "", true, false);
    }
  }

  Future<void> onClickDownloadStockButton() async {
    bool isInternet = await AppUtils.interNetCheck();
    if (isInternet) {
      getAllStockListApi(true);
      // getAllProductListApi(false, true);
    } else {
      AppUtils.showSnackBarMessage('no_internet'.tr);
    }
  }

  Future<void> onClickUploadStockButton() async {
    bool isInternet = await AppUtils.interNetCheck();
    if (isInternet) {
      storeStockData(true);
    } else {
      AppUtils.showSnackBarMessage('no_internet'.tr);
    }
  }

  Future<void> onClickSyncStockButton() async {
    bool isInternet = await AppUtils.interNetCheck();
    if (isInternet) {
      storeStockData(true);
    } else {
      AppUtils.showSnackBarMessage('no_internet'.tr);
    }
  }

  void storeStockData(bool isProgress) {
    if (isLocalStocksAvailable()) {
      List<StockStoreRequest> list = AppStorage().getStoredStockList();
      storeLocalStocksAPI(isProgress, jsonEncode(list));
    } else if (isLocalProductsAvailable()) {
      storeLocalProducts(isProgress, getLocalStoredProduct());
    } else {
      getAllStockListApi(isProgress);
    }
  }

  void storeProductData() {
    if (AppStorage().getStockData() != null) {
      ProductListResponse response = AppStorage().getStockData()!;
      if (response.info!.isNotEmpty) {
        List<ProductInfo> list = [];
        for (int i = 0; i < response.info!.length; i++) {
          bool isLocalStored = response.info![i].localStored!;
          if (isLocalStored) {
            list.add(response.info![i]);
          }
        }
        if (list.isNotEmpty) {}
      }
    }
  }

  bool isLocalStocksAvailable() {
    bool isAvailable = false;
    List<StockStoreRequest> list = AppStorage().getStoredStockList();
    if (list.isNotEmpty) isAvailable = true;

    return isAvailable;
  }

  bool isLocalProductsAvailable() {
    bool isAvailable = false;
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
        if (list.isNotEmpty) {
          isAvailable = true;
        }
      }
    }
    return isAvailable;
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
