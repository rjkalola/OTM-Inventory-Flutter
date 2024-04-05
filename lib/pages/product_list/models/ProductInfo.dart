class ProductInfo {
  int? id;
  String? uuid;
  int? companyId;
  String? supplierId;
  String? shortName;
  String? name;
  String? description;
  String? price;
  String? image;
  String? extension;
  String? qrCode;
  String? dateAvailable;
  bool? status;
  int? isArchived;
  int? addedBy;
  String? deletedAt;
  String? createdAt;
  String? updatedAt;
  String? categoryName;
  String? currency;
  String? sku;
  String? model;
  String? manufacturer;
  String? imageThumb;
  String? qrCodeThumb;
  String? imageThumbUrl;
  String? imageUrl;
  String? supplier;

  ProductInfo(
      {this.id,
        this.uuid,
        this.companyId,
        this.supplierId,
        this.shortName,
        this.name,
        this.description,
        this.price,
        this.image,
        this.extension,
        this.qrCode,
        this.dateAvailable,
        this.status,
        this.isArchived,
        this.addedBy,
        this.deletedAt,
        this.createdAt,
        this.updatedAt,
        this.categoryName,
        this.currency,
        this.sku,
        this.model,
        this.manufacturer,
        this.imageThumb,
        this.qrCodeThumb,
        this.imageThumbUrl,
        this.imageUrl,
        this.supplier});

  ProductInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    uuid = json['uuid'];
    companyId = json['company_id'];
    supplierId = json['supplier_id'];
    shortName = json['short_name'];
    name = json['name'];
    description = json['description'];
    price = json['price'];
    image = json['image'];
    extension = json['extension'];
    qrCode = json['qr_code'];
    dateAvailable = json['date_available'];
    status = json['status'];
    isArchived = json['is_archived'];
    addedBy = json['added_by'];
    deletedAt = json['deleted_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    categoryName = json['category_name'];
    currency = json['currency'];
    sku = json['sku'];
    model = json['model'];
    manufacturer = json['manufacturer'];
    imageThumb = json['image_thumb'];
    qrCodeThumb = json['qr_code_thumb'];
    imageThumbUrl = json['image_thumb_url'];
    imageUrl = json['image_url'];
    supplier = json['supplier'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['uuid'] = this.uuid;
    data['company_id'] = this.companyId;
    data['supplier_id'] = this.supplierId;
    data['short_name'] = this.shortName;
    data['name'] = this.name;
    data['description'] = this.description;
    data['price'] = this.price;
    data['image'] = this.image;
    data['extension'] = this.extension;
    data['qr_code'] = this.qrCode;
    data['date_available'] = this.dateAvailable;
    data['status'] = this.status;
    data['is_archived'] = this.isArchived;
    data['added_by'] = this.addedBy;
    data['deleted_at'] = this.deletedAt;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['category_name'] = this.categoryName;
    data['currency'] = this.currency;
    data['sku'] = this.sku;
    data['model'] = this.model;
    data['manufacturer'] = this.manufacturer;
    data['image_thumb'] = this.imageThumb;
    data['qr_code_thumb'] = this.qrCodeThumb;
    data['image_thumb_url'] = this.imageThumbUrl;
    data['image_url'] = this.imageUrl;
    data['supplier'] = this.supplier;
    return data;
  }
}