import 'package:otm_inventory/pages/purchase_order/purchase_order_details/model/purchase_order_qty_info.dart';

class PurchaseOrderReceiveRequest {
  int? supplierId, storeId, orderId;
  String? note, receiveId, receiveDate, productData;

  PurchaseOrderReceiveRequest(
      {this.productData,
      this.supplierId,
      this.storeId,
      this.note,
      this.receiveId,
      this.receiveDate,
      this.orderId});

  PurchaseOrderReceiveRequest.fromJson(Map<String, dynamic> json) {
    // if (json['product_data'] != null) {
    //   productData = <PurchaseOrderQtyInfo>[];
    //   json['product_data'].forEach((v) {
    //     productData!.add(PurchaseOrderQtyInfo.fromJson(v));
    //   });
    // }
    productData = json['productData'];
    supplierId = json['supplier_id'];
    storeId = json['store_id'];
    note = json['note'];
    receiveId = json['receive_id'];
    receiveDate = json['receive_date'];
    orderId = json['order_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    // if (productData != null) {
    //   data['product_data'] = productData!.map((v) => v.toJson()).toList();
    // }
    data['product_data'] = productData;
    data['supplier_id'] = supplierId;
    data['store_id'] = storeId;
    data['note'] = note;
    data['receive_id'] = receiveId;
    data['receive_date'] = receiveDate;
    data['order_id'] = orderId;
    return data;
  }
}
