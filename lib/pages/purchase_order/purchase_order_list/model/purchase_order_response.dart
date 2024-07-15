import 'package:otm_inventory/pages/purchase_order/purchase_order_list/model/purchase_order_info.dart';

class PurchaseOrderResponse {
  bool? IsSuccess;
  String? Message;
  List<PurchaseOrderInfo>? info;

  PurchaseOrderResponse({this.IsSuccess, this.Message, this.info});

  PurchaseOrderResponse.fromJson(Map<String, dynamic> json) {
    IsSuccess = json['IsSuccess'];
    Message = json['Message'];
    if (json['Info'] != null) {
      info = <PurchaseOrderInfo>[];
      json['Info'].forEach((v) {
        info!.add(PurchaseOrderInfo.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['IsSuccess'] = IsSuccess;
    data['Message'] = Message;
    if (info != null) {
      data['Info'] = info!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
