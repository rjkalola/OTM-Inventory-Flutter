import 'package:otm_inventory/web_services/response/base_response.dart';
import '../../../common/model/file_info.dart';

class AddLocalProductRequest extends BaseResponse {
  int? id,
      supplier_id,
      manufacturer_id,
      mode_type,
      qty;
  String? shortName,
      name,
      price,
      description,
      barcode_text;
  List<FilesInfo>? temp_images;
  bool? status;

  AddLocalProductRequest(
      {this.id,
      this.shortName,
      this.name,
      this.supplier_id,
      this.manufacturer_id,
      this.price,
      this.description,
      this.barcode_text,
      this.status,
      this.mode_type,
      this.qty,
      this.temp_images});

  AddLocalProductRequest.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    supplier_id = json['supplier_id'];
    shortName = json['short_name'];
    name = json['name'];
    description = json['description'];
    price = json['price'];
    status = json['status'];
    manufacturer_id = json['manufacturer_id'];
    qty = json['qty'];
    if (json['temp_images'] != null) {
      temp_images = <FilesInfo>[];
      json['temp_images'].forEach((v) {
        temp_images!.add(FilesInfo.fromJson(v));
      });
    }
    barcode_text = json['barcode_text'];
    mode_type = json['mode_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['supplier_id'] = supplier_id;
    data['short_name'] = shortName;
    data['name'] = name;
    data['description'] = description;
    data['price'] = price;
    data['status'] = status;
    data['manufacturer_id'] = manufacturer_id;
    data['qty'] = qty;
    data['barcode_text'] = barcode_text;
    data['mode_type'] = mode_type;
    if (temp_images != null) {
      data['temp_images'] = temp_images!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
