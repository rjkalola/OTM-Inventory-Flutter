import 'package:otm_inventory/pages/products/order_list/model/order_info.dart';

class OrderListResponse {
  bool? isSuccess;
  String? message;
  String? fromDate;
  String? toDate;
  List<OrderInfo>? info;
  int? total;
  int? offset;

  OrderListResponse(
      {this.isSuccess,
      this.message,
      this.fromDate,
      this.toDate,
      this.info,
      this.total,
      this.offset});

  OrderListResponse.fromJson(Map<String, dynamic> json) {
    isSuccess = json['IsSuccess'];
    message = json['Message'];
    fromDate = json['from_date'];
    toDate = json['to_date'];
    if (json['info'] != null) {
      info = <OrderInfo>[];
      json['info'].forEach((v) {
        info!.add(new OrderInfo.fromJson(v));
      });
    }
    total = json['total'];
    offset = json['offset'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['IsSuccess'] = this.isSuccess;
    data['Message'] = this.message;
    data['from_date'] = this.fromDate;
    data['to_date'] = this.toDate;
    if (this.info != null) {
      data['info'] = this.info!.map((v) => v.toJson()).toList();
    }
    data['total'] = this.total;
    data['offset'] = this.offset;
    return data;
  }
}
