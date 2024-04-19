import 'package:dio/dio.dart' as multi;
import 'package:flutter/foundation.dart';

import '../../../../web_services/api_constants.dart';
import '../../../../web_services/network/api_request.dart';
import '../../../../web_services/response/response_model.dart';

class AddProductRepository {

  void getProductResources({
    multi.FormData? formData,
    Function(ResponseModel responseModel)? onSuccess,
    Function(ResponseModel error)? onError,
  }) {
    if (kDebugMode) print("formData:$formData");
    ApiRequest(
            url: ApiConstants.getProductResourcesUrl,
            formData: formData,
            isFormData: true)
        .postRequest(
      onSuccess: (data) {
        onSuccess!(data);
      },
      onError: (error) => {if (onError != null) onError(error)},
    );
  }

  void storeProduct({
    multi.FormData? formData,
    Function(ResponseModel responseModel)? onSuccess,
    Function(ResponseModel error)? onError,
  }) {
    if (kDebugMode)print("formData:$formData");
    ApiRequest(
        url: ApiConstants.storeProductUrl, formData: formData, isFormData: true)
        .postRequest(
      onSuccess: (data) {
        onSuccess!(data);
      },
      onError: (error) => {if (onError != null) onError(error)},
    );
  }

  void getProductDetails({
    multi.FormData? formData,
    Function(ResponseModel responseModel)? onSuccess,
    Function(ResponseModel error)? onError,
  }) {
    if (kDebugMode) print("formData:$formData");
    ApiRequest(
        url: ApiConstants.getProductDetailsUrl,
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
