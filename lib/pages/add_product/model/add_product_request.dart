import 'package:otm_inventory/web_services/response/base_response.dart';
import 'package:otm_inventory/web_services/response/module_info.dart';

class AddProductRequest extends BaseResponse {
  int? id,
      supplier_id,
      lengthUnit_id,
      weightUnit_id,
      manufacturer_id,
      model_id,
      mode_type;
  String? shortName,
      name,
      sku,
      price,
      tax,
      length,
      width,
      height,
      weight,
      description;
  bool? status;

  AddProductRequest(
      {this.id,
      this.supplier_id,
      this.lengthUnit_id,
      this.weightUnit_id,
      this.manufacturer_id,
      this.model_id,
      this.mode_type});
}
