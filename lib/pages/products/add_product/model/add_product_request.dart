import 'package:otm_inventory/web_services/response/base_response.dart';
import '../../../common/model/file_info.dart';

class AddProductRequest extends BaseResponse {
  int? id,
      local_id,
      supplier_id,
      lengthUnit_id,
      weightUnit_id,
      manufacturer_id,
      model_id,
      mode_type,
      qty;
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
  List<FilesInfo>? product_images;
  bool? status;

  AddProductRequest(
      {this.id,
      this.local_id,
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
      this.mode_type,
      this.qty,
      this.product_images});

  AddProductRequest.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    local_id = json['local_id'];
    supplier_id = json['supplier_id'];
    shortName = json['short_name'];
    name = json['name'];
    description = json['description'];
    price = json['price'];
    status = json['status'];
    sku = json['sku'];
    weight = json['weight'];
    length = json['length'];
    width = json['width'];
    height = json['height'];
    tax = json['tax'];
    manufacturer_id = json['manufacturer_id'];
    weightUnit_id = json['weightUnit_id'];
    lengthUnit_id = json['lengthUnit_id'];
    model_id = json['model_id'];
    qty = json['qty'];
    if (json['product_images'] != null) {
      product_images = <FilesInfo>[];
      json['product_images'].forEach((v) {
        product_images!.add(FilesInfo.fromJson(v));
      });
    }
    barcode_text = json['barcode_text'];
    mode_type = json['mode_type'];
    if (json['categories'] != null) {
      categories = json['categories'].cast<String>();
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['local_id'] = local_id;
    data['supplier_id'] = supplier_id;
    data['short_name'] = shortName;
    data['name'] = name;
    data['description'] = description;
    data['price'] = price;
    data['status'] = status;
    data['sku'] = sku;
    data['weight'] = weight;
    data['length'] = length;
    data['width'] = width;
    data['height'] = height;
    data['tax'] = tax;
    data['manufacturer_id'] = manufacturer_id;
    data['weight_unit_id'] = weightUnit_id;
    data['length_unit_id'] = lengthUnit_id;
    data['model_id'] = model_id;
    data['qty'] = qty;
    data['barcode_text'] = barcode_text;
    data['mode_type'] = mode_type;
    if (categories != null) {
      data['categories'] = this.categories;
    }
    if (product_images != null) {
      data['product_images'] = product_images!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
