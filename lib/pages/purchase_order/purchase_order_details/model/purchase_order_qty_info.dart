import 'package:otm_inventory/pages/stock_edit_quantiry/model/stock_qty_history_info.dart';
import 'package:otm_inventory/web_services/response/base_response.dart';

class PurchaseOrderQtyInfo {
  int? product_id;
  String? received_qty;

  PurchaseOrderQtyInfo({this.product_id, this.received_qty});

  PurchaseOrderQtyInfo.fromJson(Map<String, dynamic> json) {
    product_id = json['product_id'];
    received_qty = json['received_qty'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['product_id'] = product_id;
    data['received_qty'] = received_qty;
    return data;
  }
}
