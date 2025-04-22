import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:otm_inventory/pages/common/listener/select_item_listener.dart';
import 'package:otm_inventory/pages/common/select_Item_list_dialog.dart';
import 'package:otm_inventory/pages/products/add_product/controller/add_product_repository.dart';
import 'package:otm_inventory/pages/products/import_products/controller/import_products_repository.dart';
import 'package:otm_inventory/pages/products/order_list/controller/order_list_repository.dart';
import 'package:otm_inventory/pages/products/order_list/model/order_info.dart';
import 'package:otm_inventory/pages/products/order_list/model/order_list_response.dart';
import 'package:otm_inventory/pages/products/product_list/models/product_info.dart';
import 'package:otm_inventory/pages/products/product_list/models/product_list_response.dart';
import 'package:otm_inventory/pages/stock_edit_quantiry/model/store_stock_request.dart';
import 'package:otm_inventory/pages/stock_list/stock_list_repository.dart';
import 'package:otm_inventory/routes/app_routes.dart';
import 'package:otm_inventory/utils/app_constants.dart';
import 'package:otm_inventory/utils/app_storage.dart';
import 'package:otm_inventory/utils/app_utils.dart';
import 'package:otm_inventory/utils/string_helper.dart';
import 'package:dio/dio.dart' as multi;
import 'package:otm_inventory/web_services/api_constants.dart';
import 'package:otm_inventory/web_services/response/base_response.dart';
import 'package:otm_inventory/web_services/response/module_info.dart';
import 'package:otm_inventory/web_services/response/response_model.dart';
import '../../../common/model/file_info.dart';

class OrderListController extends GetxController implements SelectItemListener {
  RxBool isLoading = false.obs,
      isInternetNotAvailable = false.obs,
      isMainViewVisible = false.obs,
      isClearVisible = false.obs,
      isOrderCheckVisible = false.obs,
      isCheckAll = false.obs;
  final search = ''.obs, fromDate = ''.obs, toDate = ''.obs;
  final offset = 0.obs;
  final _api = OrderListRepository();
  final searchController = TextEditingController().obs;
  late ScrollController scrollController;
  var itemList = <OrderInfo>[].obs;
  List<OrderInfo> tempList = [];

  @override
  void onInit() {
    super.onInit();
    scrollController = ScrollController();
    getInventoryOrderList(true);
    var arguments = Get.arguments;
    if (arguments != null) {
      // title.value = 'edit_product'.tr;
      // productId = arguments[AppConstants.intentKey.productId];
      // getProductDetails(productId);
    }
  }

  void getInventoryOrderList(bool isProgress) async {
    if (isProgress) isLoading.value = true;

    Map<String, dynamic> map = {};
    map["store_id"] = AppStorage.storeId.toString();

    var formData = multi.FormData.fromMap(map);

    print("Request Data:" + map.toString());
    _api.inventoryOrderList(
      formData: formData,
      onSuccess: (ResponseModel responseModel) {
        isLoading.value = false;
        if (responseModel.statusCode == 200) {
          OrderListResponse response =
              OrderListResponse.fromJson(jsonDecode(responseModel.result!));
          if (response.isSuccess!) {
            tempList.clear();
            tempList.addAll(response.info!);
            itemList.value = tempList;
            isMainViewVisible.value = true;
            fromDate.value = response.fromDate ?? "";
            toDate.value = response.toDate ?? "";
          } else {
            AppUtils.showSnackBarMessage(response.message!);
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

  void multipleOrderStatusUpdate(
      bool isProgress, String ids, int status) async {
    if (isProgress) isLoading.value = true;

    Map<String, dynamic> map = {};
    map["store_id"] = AppStorage.storeId.toString();
    map["goodsRequestOrderIds"] = ids;
    map["status"] = status;

    var formData = multi.FormData.fromMap(map);

    print("Request Data:" + map.toString());
    _api.multipleOrderStatusUpdate(
      formData: formData,
      onSuccess: (ResponseModel responseModel) {
        isLoading.value = false;
        if (responseModel.statusCode == 200) {
          BaseResponse response =
              BaseResponse.fromJson(jsonDecode(responseModel.result!));
          if (response.IsSuccess!) {
            isOrderCheckVisible.value = false;
            unCheckAllItems();
            isCheckAll.value = false;
            getInventoryOrderList(true);
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

  Future<void> searchItem(String value) async {
    print("Search item:" + value);
    List<OrderInfo> results = [];
    if (value.isEmpty) {
      results = tempList;
    } else {
      results = tempList
          .where((element) => (element.orderedUserName ?? "")
              .toLowerCase()
              .contains(value.toLowerCase()))
          .toList();
    }
    itemList.value = results;
  }

  Future<void> orderDetailsClick(OrderInfo? info) async {
    var arguments = {
      AppConstants.intentKey.mId: info?.id ?? 0,
    };
    var result =
        await Get.toNamed(AppRoutes.orderDetailsScreen, arguments: arguments);

    if (result != null && result) {
      getInventoryOrderList(true);
    }
  }

  void checkAllItems() {
    for (var info in itemList) {
      info.isCheckOrder = true;
    }
  }

  void unCheckAllItems() {
    for (var info in itemList) {
      info.isCheckOrder = false;
    }
  }

  showChangeOrderStatusDialog() async {
    var listOptions = <ModuleInfo>[].obs;
    ModuleInfo? info;

    info = ModuleInfo();
    info.name = 'accept'.tr;
    info.action = AppConstants.action.accept;
    listOptions.add(info);

    info = ModuleInfo();
    info.name = 'reject'.tr;
    info.action = AppConstants.action.reject;
    listOptions.add(info);

    info = ModuleInfo();
    info.name = 'cancel'.tr;
    info.action = AppConstants.action.cancel;
    listOptions.add(info);

    info = ModuleInfo();
    info.name = 'ready_to_deliver'.tr;
    info.action = AppConstants.action.readyToDeliver;
    listOptions.add(info);

    info = ModuleInfo();
    info.name = 'deliver'.tr;
    info.action = AppConstants.action.deliver;
    listOptions.add(info);

    showAttachmentOptionsDialog(
        AppConstants.dialogIdentifier.attachmentOptionsList,
        'select_status'.tr,
        listOptions,
        this);
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

  @override
  void onSelectItem(int position, int id, String name, String action) {
    if (action == AppConstants.action.accept) {
      changeStatus(AppConstants.orderStatus.ACCEPTED);
    } else if (action == AppConstants.action.reject) {
      changeStatus(AppConstants.orderStatus.REJECTED);
    } else if (action == AppConstants.action.cancel) {
      changeStatus(AppConstants.orderStatus.CANCELLED);
    } else if (action == AppConstants.action.readyToDeliver) {
      changeStatus(AppConstants.orderStatus.READY_TO_DELIVERED);
    } else if (action == AppConstants.action.deliver) {
      changeStatus(AppConstants.orderStatus.DELIVERED);
    }
  }

  void changeStatus(int status) {
    String commaSeparateIds = getCommaSeparateIds();
    multipleOrderStatusUpdate(true, commaSeparateIds, status);
  }

  String getCommaSeparateIds() {
    String commaSeparateIds = "";
    if (itemList.isNotEmpty) {
      List<String> itemIds = [];
      for (int i = 0; i < itemList.length; i++) {
        if (itemList[i].isCheckOrder ?? false) {
          itemIds.add(itemList[i].id.toString());
        }
      }
      commaSeparateIds = itemIds.join(',');
    }
    return commaSeparateIds;
  }
}
