

class CategoryInfo {
  int? id;
  String? name,createdAt,updatedAt,imageUrl,imageThumbUrl;
  bool? status;

  CategoryInfo(
      {this.id,
        this.name,
        this.status,
        this.createdAt,
        this.updatedAt,
        this.imageUrl,
        this.imageThumbUrl});

  CategoryInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    imageUrl = json['image_url'];
    imageThumbUrl = json['image_thumb_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['image_url'] = imageUrl;
    data['image_thumb_url'] = imageThumbUrl;
    return data;
  }
}
