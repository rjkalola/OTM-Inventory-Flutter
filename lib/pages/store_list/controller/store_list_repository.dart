

import 'package:dio/dio.dart' as multi;

import '../../../web_services/api_constants.dart';
import '../../../web_services/network/api_request.dart';
import '../../../web_services/response/response_model.dart';



class StoreListRepository{
  void getStoreList({
    multi.FormData? formData,
    Function(ResponseModel responseModel)? onSuccess,
    Function(ResponseModel error)? onError,
  }) {
    ApiRequest(
        url: ApiConstants.getStoreListUrl, formData: formData, isFormData: true)
        .postRequest(
      onSuccess: (data) {
        onSuccess!(data);
      },
      onError: (error) => {if (onError != null) onError(error)},
    );
  }
}