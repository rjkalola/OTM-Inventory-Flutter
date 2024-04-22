import 'dart:convert';

import 'package:dio/dio.dart' as multi;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/dashboard/dashboard_repository.dart';
import 'package:otm_inventory/pages/dashboard/tabs/home_tab/home_tab.dart';
import 'package:otm_inventory/pages/dashboard/tabs/more_tab/more_tab.dart';
import 'package:otm_inventory/pages/dashboard/tabs/profile/profile_tab.dart';
import 'package:otm_inventory/routes/app_routes.dart';

import '../../utils/app_constants.dart';
import '../../utils/app_storage.dart';
import '../../utils/app_utils.dart';
import '../../utils/data_utils.dart';
import '../../web_services/api_constants.dart';
import '../../web_services/response/module_info.dart';
import '../../web_services/response/response_model.dart';
import '../common/drop_down_list_dialog.dart';
import '../common/listener/select_item_listener.dart';
import '../store_list/model/store_info.dart';
import '../store_list/model/store_list_response.dart';
import 'models/DashboardActionItemInfo.dart';

class DashboardController extends GetxController
    with GetSingleTickerProviderStateMixin
    implements SelectItemListener {
  final _api = DashboardRepository();
  var storeList = <ModuleInfo>[].obs;

  final List<List<DashboardActionItemInfo>> listHeaderButtons = DataUtils.generateChunks(DataUtils.getHeaderActionButtonsList(), 3).obs;
  RxBool isLoading = false.obs,
      isInternetNotAvailable = false.obs,
      isMainViewVisible = false.obs;
  final selectedIndex = 0.obs;
  final pageController = PageController();
  final tabs = <Widget>[
    HomeTab(),
    ProfileTab(),
    MoreTab(),
  ];

  void onPageChanged(int index) {
    selectedIndex.value = index;
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

  @override
  void onInit() {
    super.onInit();
    AppStorage.storeId = Get.find<AppStorage>().getStoreId();
    if (AppStorage.storeId == 0) {
      getStoreListApi();
    } else {
      isMainViewVisible.value = true;
      setHealerListArray();
    }
  }

  void onActionButtonClick(String action) {
    if (action == AppConstants.action.items) {
      Get.toNamed(AppRoutes.productListScreen);
    } else if (action == AppConstants.action.store) {
      Get.toNamed(AppRoutes.storeListScreen);
    } else if (action == AppConstants.action.stocks) {
      Get.toNamed(AppRoutes.stockListScreen);
    } else if (action == AppConstants.action.suppliers) {
      Get.toNamed(AppRoutes.supplierListScreen);
    } else if (action == AppConstants.action.categories) {
      Get.toNamed(AppRoutes.categoryListScreen);
    }
  }

  void showStoreListDialog(String dialogType, String title,
      List<ModuleInfo> list, SelectItemListener listener) {
    Get.bottomSheet(
        enableDrag: false,
        isDismissible: false,
        PopScope(
          canPop: false,
          child: DropDownListDialog(
              title: title,
              dialogType: dialogType,
              list: list,
              listener: listener,
              isCloseEnable: false),
        ),
        backgroundColor: Colors.transparent,
        isScrollControlled: true);
  }

  @override
  void onSelectItem(int position, int id, String name, String action) {
    if (action == AppConstants.dialogIdentifier.storeList) {
      AppStorage.storeId = id;
      Get.find<AppStorage>().setStoreId(id);
      setHealerListArray();
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
            if (storeList.isNotEmpty) {
              showStoreListDialog(AppConstants.dialogIdentifier.storeList,
                  'stores'.tr, storeList, this);
            }else{
              setHealerListArray();
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

  void setHealerListArray(){
    listHeaderButtons.clear();
    listHeaderButtons.addAll(DataUtils.generateChunks(DataUtils.getHeaderActionButtonsList(), 3).obs);
  }
}
