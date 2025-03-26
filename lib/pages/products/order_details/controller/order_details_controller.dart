import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:otm_inventory/pages/common/listener/DialogButtonClickListener.dart';
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
import 'package:otm_inventory/res/colors.dart';
import 'package:otm_inventory/utils/AlertDialogHelper.dart';
import 'package:otm_inventory/utils/app_constants.dart';
import 'package:otm_inventory/utils/app_storage.dart';
import 'package:otm_inventory/utils/app_utils.dart';
import 'package:otm_inventory/utils/string_helper.dart';
import 'package:dio/dio.dart' as multi;
import 'package:otm_inventory/web_services/api_constants.dart';
import 'package:otm_inventory/web_services/response/base_response.dart';
import 'package:otm_inventory/web_services/response/response_model.dart';
import '../../../common/model/file_info.dart';

class OrderDetailsController extends GetxController
    implements DialogButtonClickListener {
  RxBool isLoading = false.obs,
      isInternetNotAvailable = false.obs,
      isMainViewVisible = false.obs,
      isUpdated = false.obs;
  final _api = OrderDetailsRepository();
  final orderInfo = OrderInfo().obs;
  final orderProductList = <ProductInfo>[].obs;
  final productItemsQty = <TextEditingController>[].obs;
  final userController = TextEditingController().obs;
  final noteController = TextEditingController().obs;
  final orderId = 0.obs, orderStatusInt = 0.obs;
  int selectedProductId = 0, selectedStatus = 0;

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

              productItemsQty.clear();
              orderProductList.clear();

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
              orderStatusInt.value = orderInfo.value.orderStatusInt ?? 0;
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

  void inventoryStatusUpdate(bool isProgress, int productId, int status) async {
    if (isProgress) isLoading.value = true;

    Map<String, dynamic> map = {};
    map["order_id"] = orderId.value.toString();
    map["product_id"] = productId.toString();
    map["status"] = status.toString();

    var formData = multi.FormData.fromMap(map);

    print("Request Data:" + map.toString());
    _api.inventoryStatusUpdate(
      formData: formData,
      onSuccess: (ResponseModel responseModel) {
        isLoading.value = false;
        if (responseModel.statusCode == 200) {
          BaseResponse response =
              BaseResponse.fromJson(jsonDecode(responseModel.result!));
          if (response.IsSuccess!) {
            isUpdated.value = true;
            getInventoryOrderDetails(true);
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

  Color getStatusTextColor(int status) {
    print("status:" + status.toString());
    Color? color = primaryTextColor;
    if (status == AppConstants.orderStatus.PLACED) {
      color = const Color(0xff1d7b3e);
    } else if (status == AppConstants.orderStatus.ACCEPTED) {
      color = const Color(0xff019ea4);
    } else if (status == AppConstants.orderStatus.REJECTED) {
      color = const Color(0xfff24726);
    } else if (status == AppConstants.orderStatus.IN_PROGRESS) {
      color = defaultAccentColor;
    } else if (status == AppConstants.orderStatus.READY_TO_DELIVERED) {
      color = const Color(0xff414bb2);
    } else if (status == AppConstants.orderStatus.RECEIVED) {
      color = const Color(0xff1d7b3e);
    } else if (status == AppConstants.orderStatus.DELIVERED) {
      color = const Color(0xff025393);
    } else if (status == AppConstants.orderStatus.CANCELLED) {
      color = const Color(0xfff24726);
    } else if (status == AppConstants.orderStatus.RETURNED) {
      color = const Color(0xff1d7b3e);
    }
    return color;
  }

  void showStatusUpdateDialog(int productId, int status, String message) {
    selectedProductId = productId;
    selectedStatus = status;
    AlertDialogHelper.showAlertDialog(
        "",
        'Are you sure you want to $message this order?'.tr,
        'yes'.tr,
        'no'.tr,
        "",
        true,
        this,
        AppConstants.dialogIdentifier.orderStatusChangeDialog);
  }

  @override
  void onNegativeButtonClicked(String dialogIdentifier) {
    Get.back();
  }

  @override
  void onOtherButtonClicked(String dialogIdentifier) {}

  @override
  void onPositiveButtonClicked(String dialogIdentifier) {
    if (dialogIdentifier ==
        AppConstants.dialogIdentifier.orderStatusChangeDialog) {
      print("product id:" + selectedProductId.toString());
      print("selectedStatus:" + selectedStatus.toString());
      inventoryStatusUpdate(true, selectedProductId, selectedStatus);
      Get.back();
    }
  }
}
