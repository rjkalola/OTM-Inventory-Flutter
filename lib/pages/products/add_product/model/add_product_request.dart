import 'package:otm_inventory/web_services/response/base_response.dart';

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
      description,
      barcode_text;
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
      this.manufacturer_id,
      this.model_id,
      this.sku,
      this.price,
      this.tax,
      this.description,
      this.barcode_text,
      this.status,
      this.mode_type});
}
