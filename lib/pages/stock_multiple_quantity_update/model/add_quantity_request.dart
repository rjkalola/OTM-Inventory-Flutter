import 'dart:ffi';

import 'package:otm_inventory/web_services/response/base_response.dart';
import 'package:otm_inventory/web_services/response/module_info.dart';

class AddQuantityRequest {
  int? product_id, qty;
  String? store_id,mode;

  AddQuantityRequest({
    this.store_id,
    this.product_id,
    this.qty,
    this.mode
  });

  AddQuantityRequest.fromJson(Map<String, dynamic> json) {
    product_id = json['product_id'];
    qty = json['qty'];
    store_id = json['store_id'];
    mode = json['mode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  <String, dynamic>{};
    data['product_id'] = product_id;
    data['qty'] = qty;
    data['store_id'] = store_id;
    data['mode'] = mode;
    return data;
  }
}
