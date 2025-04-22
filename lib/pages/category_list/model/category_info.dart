class CategoryInfo {
  int? id, parent_category_id, products_count;
  String? name, createdAt, updatedAt, imageUrl, imageThumbUrl, pc_name;
  bool? status;

  CategoryInfo(
      {this.id,
      this.name,
      this.parent_category_id,
      this.pc_name,
      this.status,
      this.createdAt,
      this.updatedAt,
      this.imageUrl,
      this.imageThumbUrl,
      this.products_count});

  CategoryInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    parent_category_id = json['parent_category_id'];
    pc_name = json['pc_name'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    imageUrl = json['image_url'];
    imageThumbUrl = json['image_thumb_url'];
    products_count = json['products_count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['parent_category_id'] = parent_category_id;
    data['pc_name'] = pc_name;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['image_url'] = imageUrl;
    data['image_thumb_url'] = imageThumbUrl;
    data['products_count'] = products_count;
    return data;
  }
}
