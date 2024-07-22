import 'dart:convert';
import 'package:dio/dio.dart' as multi;
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/purchase_order/purchase_order_details/controller/purchase_order_details_repository.dart';
import 'package:otm_inventory/pages/purchase_order/purchase_order_list/model/purchase_order_info.dart';
import 'package:otm_inventory/utils/app_storage.dart';
import 'package:otm_inventory/web_services/response/base_response.dart';

import '../../../../utils/app_constants.dart';
import '../../../../utils/app_utils.dart';
import '../../../../utils/string_helper.dart';
import '../../../../web_services/api_constants.dart';
import '../../../../web_services/response/response_model.dart';
import '../../../products/product_list/models/product_info.dart';
import '../../purchase_order_list/model/purchase_order_response.dart';
import '../model/purchase_order_qty_info.dart';
import '../model/purchase_order_receive_request.dart';

class PurchaseOrderDetailsController extends GetxController {
  final _api = PurchaseOrderDetailsRepository();
  RxBool isLoading = false.obs,
      isInternetNotAvailable = false.obs,
      isMainViewVisible = true.obs,
      switchScanItem = false.obs;
  final searchController = TextEditingController().obs;
  final noteController = TextEditingController().obs;
  final productItemsQty = <TextEditingController>[].obs;
  PurchaseOrderInfo? info;
  final orderProductList = <ProductInfo>[].obs;

  @override
  void onInit() {
    super.onInit();
    var arguments = Get.arguments;
    if (arguments != null) {
      info = arguments[AppConstants.intentKey.purchaseOrderInfo];
      setDetails(info);
    }
  }

  void setDetails(PurchaseOrderInfo? info) {
    if (info != null) {
      orderProductList.value = info.products!;
      productItemsQty.clear();
      for (int i = 0; i < orderProductList.length; i++) {
        var textEditController = TextEditingController();
        int newQty = (orderProductList[i].qty ?? 0) -
            (orderProductList[i].product_receive_qty ?? 0);
        textEditController.text = newQty.toString();
        productItemsQty.add(textEditController);
      }
    }
  }

  void onChangeScanSwitch(bool value) {
    switchScanItem.value = value;
  }

  Future<void> receiveOrder() async {
    final list = <PurchaseOrderQtyInfo>[];
    for (int i = 0; i < productItemsQty.length; i++) {
      var info = PurchaseOrderQtyInfo();
      info.product_id = orderProductList[i].id;
      info.received_qty = productItemsQty[i].text;
      list.add(info);
    }

    bool isInternet = await AppUtils.interNetCheck();
    print("isInternet:$isInternet");
    if (isInternet) {
      String productData = jsonEncode(list);
      receivedPurchaseOrder(true, productData);
    } else {
      final listQty = <PurchaseOrderQtyInfo>[];
      bool isOverQty = false;
      for (int i = 0; i < productItemsQty.length; i++) {
        print("value:" + productItemsQty[i].text);
        var info = PurchaseOrderQtyInfo();
        int newQty = 0;
        int receivedQty = orderProductList[i].product_receive_qty ?? 0;
        int totalQty = orderProductList[i].qty ?? 0;
        if (!StringHelper.isEmptyString(productItemsQty[i].text)) {
          newQty = int.parse(productItemsQty[i].text);
        }
        print("newQty:" + newQty.toString());
        print("receivedQty:" + receivedQty.toString());
        print("totalQty:" + totalQty.toString());

        if ((receivedQty + newQty) > totalQty) {
          isOverQty = true;
          break;
        } else {
          info.product_id = orderProductList[i].id;
          info.received_qty = productItemsQty[i].text;
          listQty.add(info);
        }
      }

      print("isOverQty:" + isOverQty.toString());
      print("listQty size:" + listQty.length.toString());
      String productData = jsonEncode(listQty);
      print("productData:" + productData);

      if (!isOverQty) {
        String productData = jsonEncode(listQty);
        // receivedPurchaseOrder(true, productData);
        PurchaseOrderReceiveRequest request = PurchaseOrderReceiveRequest();
        request.productData = productData;
        request.supplierId = info?.supplierId ?? 0;
        request.storeId = AppStorage.storeId;
        request.note = noteController.value.text;
        request.receiveId = "";
        request.receiveDate = info?.date ?? "";
        request.orderId = info?.id ?? 0;
        List<PurchaseOrderReceiveRequest> listRequest =
            AppStorage().getStoredReceivedPurchaseOrderList();
        listRequest.add(request);
        AppStorage().setStoredReceivedPurchaseOrderList(listRequest);

        print("Data" + jsonEncode(listRequest));

        updateQuantityInLocal();
      } else {
        AppUtils.showSnackBarMessage('purchase_order_received_qty_msg'.tr);
      }
    }
  }

  void updateQuantityInLocal() {
    if (AppStorage().getPurchaseOrderList() != null) {
      PurchaseOrderResponse response = AppStorage().getPurchaseOrderList()!;
      var orderList = <PurchaseOrderInfo>[];
      orderList.addAll(response.info ?? []);
      int index = 0;
      for (int i = 0; i < orderList.length; i++) {
        if (info?.id! == orderList[i].id!) {
          index = i;
          break;
        }
      }

      PurchaseOrderInfo purchaseOrderInfo = orderList[index];
      List<ProductInfo>? products = purchaseOrderInfo.products ?? [];
      for (int i = 0; i < products.length; i++) {
        ProductInfo productInfo = products[i];
        int newQty = 0;
        int receivedQty = orderProductList[i].product_receive_qty ?? 0;
        int totalQty = orderProductList[i].qty ?? 0;
        if (!StringHelper.isEmptyString(productItemsQty[i].text)) {
          newQty = int.parse(productItemsQty[i].text);
        }
        productInfo.product_receive_qty = (receivedQty + newQty);
      }
      purchaseOrderInfo.products = products;

      orderList[index] = purchaseOrderInfo;
      response.info = orderList;
      AppStorage().setPurchaseOrderList(response);
      Get.back(result: true);
    }
  }

  void receivedPurchaseOrder(bool isProgress, String productData) async {
    Map<String, dynamic> map = {};
    map["product_data"] = productData;
    map["supplier_id"] = info?.supplierId ?? "";
    map["store_id"] = AppStorage.storeId;
    map["note"] = noteController.value.text;
    map["receive_id"] = "";
    map["receive_date"] = info?.date ?? "";
    map["order_id"] = info?.id ?? 0;
    multi.FormData formData = multi.FormData.fromMap(map);
    print(map.toString());
    if (isProgress) isLoading.value = true;
    _api.receivedPurchaseOrder(
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
        isMainViewVisible.value = true;
        if (error.statusCode == ApiConstants.CODE_NO_INTERNET_CONNECTION) {
          AppUtils.showSnackBarMessage('no_internet'.tr);
        } else if (error.statusMessage!.isNotEmpty) {
          AppUtils.showSnackBarMessage(error.statusMessage!);
        }
      },
    );
  }

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
