import 'package:otm_inventory/pages/products/product_list/models/product_info.dart';

class PurchaseOrderInfo {
  int? id,companyId,supplierId,status;
  String? orderId,supplierName,date,ref,statusText,expectedDeliveryDate,createdAt,updatedAt;
  List<ProductInfo>? products;
  PurchaseOrderInfo(
      {this.id,
        this.companyId,
        this.orderId,
        this.supplierId,
        this.supplierName,
        this.date,
        this.ref,
        this.status,
        this.statusText,
        this.expectedDeliveryDate,
        this.createdAt,
        this.updatedAt,
        this.products});

  PurchaseOrderInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    companyId = json['company_id'];
    orderId = json['order_id'];
    supplierId = json['supplier_id'];
    supplierName = json['supplier_name'];
    date = json['date'];
    ref = json['ref'];
    status = json['status'];
    statusText = json['status_text'];
    expectedDeliveryDate = json['expected_delivery_date'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    if (json['products'] != null) {
      products = <ProductInfo>[];
      json['products'].forEach((v) {
        products!.add(ProductInfo.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['company_id'] = companyId;
    data['order_id'] = orderId;
    data['supplier_id'] = supplierId;
    data['supplier_name'] = supplierName;
    data['date'] = date;
    data['ref'] = ref;
    data['status'] = status;
    data['status_text'] = statusText;
    data['expected_delivery_date'] = expectedDeliveryDate;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (products != null) {
      data['products'] = products!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
