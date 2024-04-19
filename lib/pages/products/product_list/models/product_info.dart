

import '../../../../web_services/response/module_info.dart';

class ProductInfo {
  int? id,supplierId,manufacturer_id,weight_unit_id,length_unit_id,model_id,qty;
  String? shortName,name,description,price,image,extension,qrCode,categoryName,
      currency,sku,model_name,manufacturer_name,imageThumb,qrCodeThumb,imageUrl,imageThumbUrl,weight
  ,length,width,height,tax,length_unit_name,weight_unit_name,supplier_name;
  List<ModuleInfo>? categories;
  bool? status;

  ProductInfo(
      {this.id,
        this.supplierId,
        this.shortName,
        this.name,
        this.description,
        this.price,
        this.image,
        this.extension,
        this.qrCode,
        this.status,
        this.categoryName,
        this.currency,
        this.sku,
        this.model_name,
        this.manufacturer_name,
        this.imageThumb,
        this.qrCodeThumb,
        this.imageThumbUrl,
        this.imageUrl,
        this.weight,
        this.length,
        this.width,
        this.height,
        this.tax,
        this.manufacturer_id,
        this.weight_unit_id,
        this.length_unit_id,
        this.model_id,
        this.categories,
        this.length_unit_name,
        this.weight_unit_name,
        this.supplier_name,
        this.qty});

  ProductInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    supplierId = json['supplier_id'];
    shortName = json['short_name'];
    name = json['name'];
    description = json['description'];
    price = json['price'];
    image = json['image'];
    extension = json['extension'];
    qrCode = json['qr_code'];
    status = json['status'];
    categoryName = json['category_name'];
    currency = json['currency'];
    sku = json['sku'];
    model_name = json['model_name'];
    manufacturer_name = json['manufacturer_name'];
    weight = json['weight'];
    length = json['length'];
    width = json['width'];
    height = json['height'];
    imageUrl = json['image_url'];
    imageThumb = json['image_thumb'];
    qrCodeThumb = json['qr_code_thumb'];
    imageThumbUrl = json['image_thumb_url'];
    tax = json['tax'];
    manufacturer_id = json['manufacturer_id'];
    weight_unit_id = json['weight_unit_id'];
    length_unit_id = json['length_unit_id'];
    model_id = json['model_id'];
    length_unit_name = json['length_unit_name'];
    weight_unit_name = json['weight_unit_name'];
    supplier_name = json['supplier_name'];
    qty = json['qty'];
    if (json['categories'] != null) {
      categories = <ModuleInfo>[];
      json['categories'].forEach((v) {
        categories!.add(ModuleInfo.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['supplier_id'] = supplierId;
    data['short_name'] = shortName;
    data['name'] = name;
    data['description'] = description;
    data['price'] = price;
    data['image'] = image;
    data['extension'] = extension;
    data['qr_code'] = qrCode;
    data['status'] = status;
    data['category_name'] = categoryName;
    data['currency'] = currency;
    data['sku'] = sku;
    data['model_name'] = model_name;
    data['manufacturer_name'] = manufacturer_name;
    data['image_thumb'] = imageThumb;
    data['qr_code_thumb'] = qrCodeThumb;
    data['image_thumb_url'] = imageThumbUrl;
    data['image_url'] = imageUrl;
    data['weight'] = weight;
    data['length'] = length;
    data['width'] = width;
    data['height'] = height;
    data['tax'] = tax;
    data['manufacturer_id'] = manufacturer_id;
    data['weight_unit_id'] = weight_unit_id;
    data['length_unit_id'] = length_unit_id;
    data['model_id'] = model_id;
    data['length_unit_name'] = length_unit_name;
    data['weight_unit_name'] = weight_unit_name;
    data['supplier_name'] = supplier_name;
    data['qty'] = qty;

    if (categories != null) {
      data['categories'] = categories!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
