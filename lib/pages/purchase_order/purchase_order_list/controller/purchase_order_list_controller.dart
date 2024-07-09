import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/purchase_order/purchase_order_list/controller/purchase_order_list_repository.dart';
import 'package:otm_inventory/pages/store_list/model/store_info.dart';

class PurchaseOrderListController extends GetxController {
  final _api = PurchaseOrderListRepository();
  var orderList = <StoreInfo>[].obs;
  List<StoreInfo> tempList = [];
  final searchController = TextEditingController().obs;
  RxBool isLoading = false.obs,
      isInternetNotAvailable = false.obs,
      isMainViewVisible = true.obs,
      isClearVisible = false.obs;
  final offset = 0.obs;

  @override
  void onInit() {
    super.onInit();
    // getPurchaseOrderListApi(true);
  }

  // void getPurchaseOrderListApi(bool isProgress) async {
  //   Map<String, dynamic> map = {};
  //   multi.FormData formData = multi.FormData.fromMap(map);
  //
  //   if (isProgress) isLoading.value = true;
  //   _api.getStoreList(
  //     formData: formData,
  //     onSuccess: (ResponseModel responseModel) {
  //       isLoading.value = false;
  //       if (responseModel.statusCode == 200) {
  //         StoreListResponse response =
  //             StoreListResponse.fromJson(jsonDecode(responseModel.result!));
  //         if (response.IsSuccess!) {
  //           tempList.clear();
  //           tempList.addAll(response.info!);
  //           storeList.value = tempList;
  //           isMainViewVisible.value = true;
  //           print("Array Lenth:" + response.info!.length.toString());
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

  // Future<void> addStoreClick(StoreInfo? info) async {
  //   var result;
  //   if (info != null) {
  //     var arguments = {
  //       AppConstants.intentKey.storeInfo: info,
  //     };
  //     result =
  //         await Get.toNamed(AppRoutes.addStoreScreen, arguments: arguments);
  //   } else {
  //     result = await Get.toNamed(AppRoutes.addStoreScreen);
  //   }
  //
  //   if (result != null && result) {
  //     getStoreListApi(true);
  //   }
  // }

  Future<void> searchItem(String value) async {
    List<StoreInfo> results = [];
    if (value.isEmpty) {
      results = tempList;
    } else {
      results = tempList
          .where((element) =>
          element.storeName!.toLowerCase().contains(value.toLowerCase()))
          .toList();
    }
    orderList.value = results;
  }

}