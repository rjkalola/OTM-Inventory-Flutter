import 'package:otm_inventory/web_services/response/status.dart';

class ApiResponse<T> {
  Status? status;
  T? data;
  String? message;
  int? statusCode;

  ApiResponse(this.status, this.data, this.message);

  ApiResponse.loading() : status = Status.LOADING;

  ApiResponse.completed() : status = Status.COMPLETED;

  ApiResponse.error(this.statusCode, this.message) : status = Status.ERROR;

  @override
  String toString() {
    return "Status: $status \n Data: $data \n Message: $message \n Status Code: $statusCode";
  }
}
