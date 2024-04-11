import 'dart:ffi';

import 'package:otm_inventory/web_services/response/base_response.dart';
import 'package:otm_inventory/web_services/response/module_info.dart';

class AddProductRequest extends BaseResponse {
  int? id,
      supplier_id,
      lengthUnit_id,
      weightUnit_id,
      mode_type;
  String? shortName,
      name,
      manufacturer,
      model,
      sku,
      price,
      tax,
      length,
      width,
      height,
      weight,
      description;
  List<String>? categories = [];
  bool? status;

  AddProductRequest(
      {this.id,
      this.shortName,
      this.name,
      this.categories,
      this.supplier_id,
      this.length,
      this.width,
      this.height,
      this.lengthUnit_id,
      this.weight,
      this.weightUnit_id,
      this.manufacturer,
      this.model,
      this.sku,
      this.price,
      this.tax,
      this.description,
      this.status,
      this.mode_type});
}
