import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:otm_inventory/pages/products/add_product/controller/add_product_repository.dart';
import 'package:otm_inventory/pages/products/import_products/controller/import_products_repository.dart';
import 'package:otm_inventory/pages/products/order_details/controller/order_details_repository.dart';
import 'package:otm_inventory/pages/products/order_details/model/order_details_response.dart';
import 'package:otm_inventory/pages/products/order_list/controller/order_list_repository.dart';
import 'package:otm_inventory/pages/products/order_list/model/order_info.dart';
import 'package:otm_inventory/pages/products/order_list/model/order_list_response.dart';
import 'package:otm_inventory/pages/products/product_list/models/product_info.dart';
import 'package:otm_inventory/pages/products/product_list/models/product_list_response.dart';
import 'package:otm_inventory/pages/stock_edit_quantiry/model/store_stock_request.dart';
import 'package:otm_inventory/pages/stock_list/stock_list_repository.dart';
import 'package:otm_inventory/utils/app_constants.dart';
import 'package:otm_inventory/utils/app_storage.dart';
import 'package:otm_inventory/utils/app_utils.dart';
import 'package:otm_inventory/utils/string_helper.dart';
import 'package:dio/dio.dart' as multi;
import 'package:otm_inventory/web_services/api_constants.dart';
import 'package:otm_inventory/web_services/response/base_response.dart';
import 'package:otm_inventory/web_services/response/response_model.dart';
import '../../../common/model/file_info.dart';

class OrderDetailsController extends GetxController {
  RxBool isLoading = false.obs,
      isInternetNotAvailable = false.obs,
      isMainViewVisible = false.obs,
      isUpdated = false.obs;
  final _api = OrderDetailsRepository();
  final orderInfo = OrderInfo().obs;
  final orderProductList = <ProductInfo>[].obs;
  final productItemsQty = <TextEditingController>[].obs;
  final userController = TextEditingController().obs;
  final orderId = 0.obs;

  @override
  void onInit() {
    super.onInit();
    var arguments = Get.arguments;
    if (arguments != null) {
      orderId.value = arguments[AppConstants.intentKey.mId];
      getInventoryOrderDetails(true);
    }
  }

  void getInventoryOrderDetails(bool isProgress) async {
    if (isProgress) isLoading.value = true;

    Map<String, dynamic> map = {};
    map["order_id"] = orderId.value.toString();

    var formData = multi.FormData.fromMap(map);

    print("Request Data:" + map.toString());
    _api.inventoryOrderDetails(
      formData: formData,
      onSuccess: (ResponseModel responseModel) {
        isLoading.value = false;
        if (responseModel.statusCode == 200) {
          OrderDetailsResponse response =
              OrderDetailsResponse.fromJson(jsonDecode(responseModel.result!));
          if (response.isSuccess!) {
            if (response.info != null) {
              orderInfo.value = response.info!;
              if (!StringHelper.isEmptyList(response.info?.orderProducts)) {
                for (int i = 0; i < response.info!.orderProducts!.length; i++) {
                  ProductInfo info = response.info!.orderProducts![i];
                  var textEditController = TextEditingController();
                  textEditController.text = info.qty.toString();
                  productItemsQty.add(textEditController);
                  orderProductList.add(info);
                }
              }
              isMainViewVisible.value = true;
            }
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
}
