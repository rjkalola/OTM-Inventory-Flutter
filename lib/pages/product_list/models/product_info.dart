class ProductInfo {
  int? id;
  int? supplierId;
  String? shortName;
  String? name;
  String? description;
  String? price;
  String? image;
  String? extension;
  String? qrCode;
  bool? status;
  String? categoryName;
  String? currency;
  String? sku;
  String? model;
  String? manufacturer;
  String? imageThumb;
  String? qrCodeThumb;
  String? imageThumbUrl;
  String? imageUrl;

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
        this.model,
        this.manufacturer,
        this.imageThumb,
        this.qrCodeThumb,
        this.imageThumbUrl,
        this.imageUrl,});

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
    model = json['model'];
    manufacturer = json['manufacturer'];
    imageThumb = json['image_thumb'];
    qrCodeThumb = json['qr_code_thumb'];
    imageThumbUrl = json['image_thumb_url'];
    imageUrl = json['image_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['supplier_id'] = this.supplierId;
    data['short_name'] = this.shortName;
    data['name'] = this.name;
    data['description'] = this.description;
    data['price'] = this.price;
    data['image'] = this.image;
    data['extension'] = this.extension;
    data['qr_code'] = this.qrCode;
    data['status'] = this.status;
    data['category_name'] = this.categoryName;
    data['currency'] = this.currency;
    data['sku'] = this.sku;
    data['model'] = this.model;
    data['manufacturer'] = this.manufacturer;
    data['image_thumb'] = this.imageThumb;
    data['qr_code_thumb'] = this.qrCodeThumb;
    data['image_thumb_url'] = this.imageThumbUrl;
    data['image_url'] = this.imageUrl;
    return data;
  }
}