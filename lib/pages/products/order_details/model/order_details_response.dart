import 'package:otm_inventory/pages/products/order_list/model/order_info.dart';

class OrderDetailsResponse {
  bool? isSuccess;
  String? message;
  OrderInfo? info;

  OrderDetailsResponse({this.isSuccess, this.message, this.info});

  OrderDetailsResponse.fromJson(Map<String, dynamic> json) {
    isSuccess = json['IsSuccess'];
    message = json['Message'];
    info = json['info'] != null ? new OrderInfo.fromJson(json['info']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['IsSuccess'] = this.isSuccess;
    data['Message'] = this.message;
    if (this.info != null) {
      data['info'] = this.info!.toJson();
    }
    return data;
  }
}
