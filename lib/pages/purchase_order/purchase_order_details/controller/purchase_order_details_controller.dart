import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/purchase_order/purchase_order_details/controller/purchase_order_details_repository.dart';

class PurchaseOrderDetailsController extends GetxController {
  final _api = PurchaseOrderDetailsRepository();
  RxBool isLoading = false.obs,
      isInternetNotAvailable = false.obs,
      isMainViewVisible = true.obs;
  final searchController = TextEditingController().obs;
  final noteController = TextEditingController().obs;

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
}
