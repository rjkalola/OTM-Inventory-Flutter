import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart' as multi;
import 'package:get/get.dart';
import 'package:otm_inventory/web_services/api_constants.dart';

import '../response/response_model.dart';
import 'api_exception.dart';

class ApiRequest {
  final String url;
  final dynamic data;
  final Map<String, dynamic>? queryParameters;
  var response;
  multi.FormData? formData;
  bool? isFormData = false;
  late Dio dio;

  // live
  //final BASE_URL = "http://distportal.navneet.com/mobile/";

  ApiRequest(
      {required this.url,
      this.data,
      this.formData,
      this.queryParameters,
      this.isFormData = false});

  Future<bool> interNetCheck() async {
    try {
      dio = Dio();
      dio.options.connectTimeout = const Duration(minutes: 3); //3 minutes
      dio.options.receiveTimeout = const Duration(minutes: 3); //3 minutes
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

  // Future<bool> interNetCheck() async {
  //   try {
  //     final foo = await InternetAddress.lookup('google.com');
  //     return foo.isNotEmpty && foo[0].rawAddress.isNotEmpty ? true : false;
  //   } catch (e) {
  //     return false;
  //   }
  // }

  Future<dynamic> getRequest({
    Function(dynamic data)? onSuccess,
    Function(dynamic error)? onError,
  }) async {
    ResponseModel responseModel;
    try {
      bool isInternet = await interNetCheck();
      if (isInternet) {
        response = await dio.get(
          url,
          queryParameters: queryParameters,
          options: Options(
            headers: ApiConstants.getHeader(),
          ),
        );
        if (kDebugMode) print("Response Data ==> ${response.data}");
        if (response.statusCode == 200) {
          responseModel = returnResponse(jsonEncode(response.data),
              response.statusCode, response.statusMessage);
        } else {
          responseModel =
              returnResponse(null, response.statusCode, response.statusMessage);
        }
        if (onSuccess != null) onSuccess(responseModel);
      } else {
        responseModel = returnResponse(
            null, ApiConstants.CODE_NO_INTERNET_CONNECTION, 'try_again'.tr);
        if (onError != null) onError(responseModel);
      }
    } on DioException catch (e) {
      final ApiException apiException = ApiException.fromDioError(e);
      if (kDebugMode) print("Error in api call $apiException.message");
      responseModel = returnResponse(null, 0, apiException.message);
    }
    return responseModel;
    /* catch (e) {
      e.printError();
      if (kDebugMode) print("Error in api call $e");
      var responseModel = ResponseModel(
          result: null,
          statusCode: 0,
          statusMessage: e.toString());
      if (onError != null) onError(responseModel);
      // if (onError != null) onError(e);
    }*/
  }

  Future<dynamic> postRequest({
    Function()? beforeSend,
    Function(dynamic data)? onSuccess,
    Function(dynamic error)? onError,
  }) async {
    ResponseModel responseModel;
    try {
      bool isInternet = await interNetCheck();
      if (isInternet) {
        if (kDebugMode) print("URL ==> $url");
        if (!isFormData!) {
          if (kDebugMode)  print("Request Data ==> ${data.toString()}");
          response = await dio.post(
            url,
            data: data,
            options: Options(
              headers: ApiConstants.getHeader(),
            ),
          );
        } else {
          if (kDebugMode)  print("Request Data ==> ${formData.toString()}");
          multi.Dio dio = multi.Dio();
          response = await dio.post(
            url,
            data: formData,
            options: Options(
              headers: ApiConstants.getHeader(),
            ),
          );
        }
        if (kDebugMode) print("Response Data ==> ${response.data}");

        if (response.statusCode == 200) {
          responseModel = returnResponse(jsonEncode(response.data),
              response.statusCode, response.statusMessage);
        } else {
          responseModel =
              returnResponse(null, response.statusCode, response.statusMessage);
        }
        if (onSuccess != null) onSuccess(responseModel);
      } else {
        responseModel = returnResponse(
            null, ApiConstants.CODE_NO_INTERNET_CONNECTION, 'try_again'.tr);
        if (onError != null) onError(responseModel);
      }
    } on DioException catch (e) {
      final ApiException apiException = ApiException.fromDioError(e);
      if (kDebugMode) print("Error in api call $apiException.message");
      responseModel = returnResponse(null, 0, apiException.message);
    }
    return responseModel;
  }

  ResponseModel returnResponse(
      String? result, int? statusCode, String? statusMessage) {
    var responseModel = ResponseModel(
        result: result, statusCode: statusCode, statusMessage: statusMessage);
    return responseModel;
  }
}
