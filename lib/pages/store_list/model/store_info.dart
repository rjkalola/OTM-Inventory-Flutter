class StoreInfo {
  int? id;
  int? phoneExtensionId;
  String? storeName;
  String? phone;
  String? phoneWithExtension;
  String? address;
  bool? status;
  String? createdAt;
  String? updatedAt;

  StoreInfo(
      {this.id,
        this.phoneExtensionId,
        this.storeName,
        this.phone,
        this.phoneWithExtension,
        this.address,
        this.status,
        this.createdAt,
        this.updatedAt});

  StoreInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    phoneExtensionId = json['phone_extension_id'];
    storeName = json['store_name'];
    phone = json['phone'];
    phoneWithExtension = json['phone_with_extension'];
    address = json['address'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  Map<String, dynamic>();
    data['id'] = id;
    data['phone_extension_id'] = phoneExtensionId;
    data['store_name'] = storeName;
    data['phone'] = phone;
    data['phone_with_extension'] = phoneWithExtension;
    data['address'] = address;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
