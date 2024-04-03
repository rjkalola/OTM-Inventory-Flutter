import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/utils/utils.dart';
import 'package:otm_inventory/web_services/api_constants.dart';
import 'package:otm_inventory/web_services/network/api_exception.dart';
import 'package:otm_inventory/web_services/network/base_api_services.dart';
import 'package:dio/dio.dart';

import '../response/response_model.dart';

class ApiServices extends BaseApiServices {
  // @override
  // Future getApi(String url) async{
  //   Dio dio = Dio();
  //   final response = await dio.get(
  //     url,
  //     queryParameters: queryParameters,
  //     options: Options(
  //       headers: {"x-access-token": ""},
  //     ),
  //   );
  //
  // }

  Future<bool> interNetCheck() async {
    try {
      Dio dio = Dio();
      dio.options.connectTimeout = 180000 as Duration?; //3 minutes
      dio.options.receiveTimeout = 180000 as Duration?; //3 minutes
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      } else {
        return false;
      }
    } on Exception {
      return false;
    }
  }

  // Future<void> getRequest({
  //   Function(dynamic data)? onSuccess,
  //   Function(dynamic error)? onError,
  // }) async {
  //   try {
  //     bool isInternet = await interNetCheck();
  //     if (isInternet) {
  //       response = await dio.get(
  //         url,
  //         queryParameters: queryParameters,
  //         options: Options(
  //           headers: ApiConstants.getHeader(),
  //         ),
  //       );
  //       ResponseModel responseModel;
  //       if (kDebugMode) print("Response Data ==> ${response.data}");
  //
  //       if (response.statusCode == 200) {
  //         responseModel = ResponseModel(
  //             result: response.data,
  //             statusCode: response.statusCode,
  //             statusMessage: response.statusMessage);
  //       } else {
  //         responseModel = ResponseModel(
  //             result: null,
  //             statusCode: response.statusCode,
  //             statusMessage: response.statusMessage);
  //       }
  //       if (onSuccess != null) onSuccess(responseModel);
  //     } else {
  //       var responseModel = ResponseModel(
  //           result: null,
  //           statusCode: ApiConstants.CODE_NO_INTERNET_CONNECTION,
  //           statusMessage: 'try_again'.tr);
  //       if (onError != null) onError(responseModel);
  //     }
  //   } catch (e) {
  //     if (kDebugMode) print("Error in api call $e");
  //     if (onError != null) onError(e);
  //   }
  // }

  @override
  Future getApi(String url) async {
    if (kDebugMode) {
      print(url);
    }
    ResponseModel responseModel;
    Dio dio = Dio();
    try {
      bool isInternet = await interNetCheck();
      if (isInternet) {
        final response = await dio.get(
          url,
          options: Options(
            headers: ApiConstants.getHeader(),
          ),
        );
        if (response.statusCode == 200) {
          if (kDebugMode) print("Response Data ==> ${response.data}");
          responseModel = returnResponse(response.data, response.statusCode, response.statusMessage);
        } else {
          responseModel = returnResponse(null, response.statusCode, response.statusMessage);
        }
      }else{
        responseModel = returnResponse(null, ApiConstants.CODE_NO_INTERNET_CONNECTION, 'try_again'.tr);
        // if (onError != null) onError(responseModel);

      }
    }on DioException catch (e) {
      final ApiException apiException = ApiException.fromDioError(e);
      // throw apiException.message;
      responseModel = returnResponse(null, 0,apiException.message);
      // Utils.showSnackBarMessage(apiException.message);
      // apiException.message
    }
    return responseModel;

    // dynamic responseJson;
    // try {
    //   responseJson = returnResponse(response);
    //   return responseJson;
    //   print("222222");
    // } on DioException catch (e) {
    //   print("3333333");
    //   final ApiException apiException = ApiException.fromDioError(e);
    //   throw apiException.message;
    //   // Utils.showSnackBarMessage(apiException.message);
    //   // apiException.message
    // }
    // return responseJson;
  }

  @override
  Future postApi(var data, String url) async {
    if (kDebugMode) {
      print(url);
      print(data);
    }
    Dio dio = Dio();
    dynamic responseJson;
    ResponseModel responseModel;
    try {
      final response = await dio.get(
        url,
        data: jsonEncode(data),
        options: Options(
          headers: ApiConstants.getHeader(),
        ),
      );
      // responseJson = returnResponse(response);
      responseModel = returnResponse(response.data, response.statusCode, response.statusMessage);
      return responseModel;
    } on DioException catch (e) {
      final ApiException apiException = ApiException.fromDioError(e);
      throw apiException.message;
      Utils.showSnackBarMessage(apiException.message);
      // apiException.message
    }
  }

  // dynamic returnResponse(Response<dynamic> response) {
  //   dynamic responseJson = response.data;
  //   print("response.statusCode:" + response.statusCode.toString());
  //   switch (response.statusCode) {
  //     case 200:
  //       return responseJson;
  //     // case 400:
  //     default:
  //       String error = responseJson['Message'];
  //       throw error;
  //   }
  // }

  ResponseModel returnResponse(String? result,int? statusCode,String? statusMessage){
    var responseModel = ResponseModel(
        result: result,
        statusCode: statusCode,
        statusMessage: statusMessage);
    return responseModel;
  }
}
