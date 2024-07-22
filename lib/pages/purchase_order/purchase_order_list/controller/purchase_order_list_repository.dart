

import 'package:dio/dio.dart' as multi;
import 'package:flutter/foundation.dart';

import '../../../../web_services/api_constants.dart';
import '../../../../web_services/network/api_request.dart';
import '../../../../web_services/response/response_model.dart';

class PurchaseOrderListRepository{
  void getPurchaseOrders({
    multi.FormData? formData,
    Function(ResponseModel responseModel)? onSuccess,
    Function(ResponseModel error)? onError,
  }) {
    ApiRequest(
        url: ApiConstants.getPurchaseOrders, formData: formData, isFormData: true)
        .postRequest(
      onSuccess: (data) {
        onSuccess!(data);
      },
      onError: (error) => {if (onError != null) onError(error)},
    );
  }

  void storeLocalPurchaseOrderUrl({
    multi.FormData? formData,
    Function(ResponseModel responseModel)? onSuccess,
    Function(ResponseModel error)? onError,
  }) {
    if (kDebugMode) print("formData:$formData");
    ApiRequest(
        url: ApiConstants.storeLocalPurchaseOrderUrl,
        formData: formData,
        isFormData: true)
        .postRequest(
      onSuccess: (data) {
        onSuccess!(data);
      },
      onError: (error) => {if (onError != null) onError(error)},
    );
  }
}