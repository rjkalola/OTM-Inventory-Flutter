class ProductImageInfo {
  int? id;
  int? productId;
  int? addedBy;
  String? image;
  String? extension;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;
  String? imageThumbUrl;
  String? imageUrl;

  ProductImageInfo(
      {this.id,
        this.productId,
        this.addedBy,
        this.image,
        this.extension,
        this.createdAt,
        this.updatedAt,
        this.deletedAt,
        this.imageThumbUrl,
        this.imageUrl});

  ProductImageInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    productId = json['product_id'];
    addedBy = json['added_by'];
    image = json['image'];
    extension = json['extension'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    imageThumbUrl = json['image_thumb_url'];
    imageUrl = json['image_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['product_id'] = productId;
    data['added_by'] = addedBy;
    data['image'] = image;
    data['extension'] = extension;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['deleted_at'] = deletedAt;
    data['image_thumb_url'] = imageThumbUrl;
    data['image_url'] = imageUrl;
    return data;
  }
}
