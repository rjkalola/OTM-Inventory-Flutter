import '../../../web_services/response/module_info.dart';

class StoreInfo {
  int? id,phoneExtensionId;
  String? storeName,phone,phoneExtensionName,flagName,phoneWithExtension,address,createdAt,updatedAt;
  List<ModuleInfo>? user;
  bool? status;

  StoreInfo(
      {this.id,
        this.phoneExtensionId,
        this.storeName,
        this.phone,
        this.phoneExtensionName,
        this.flagName,
        this.phoneWithExtension,
        this.address,
        this.user,
        this.status,
        this.createdAt,
        this.updatedAt});

  StoreInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    phoneExtensionId = json['phone_extension_id'];
    storeName = json['store_name'];
    phone = json['phone'];
    phoneExtensionName = json['phone_extension_name'];
    flagName = json['flag_name'];
    phoneWithExtension = json['phone_with_extension'];
    address = json['address'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    if (json['user'] != null) {
      user = <ModuleInfo>[];
      json['user'].forEach((v) {
        user!.add(ModuleInfo.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  <String, dynamic>{};
    data['id'] = id;
    data['phone_extension_id'] = phoneExtensionId;
    data['store_name'] = storeName;
    data['phone'] = phone;
    data['phone_extension_name'] = phoneExtensionName;
    data['flag_name'] = flagName;
    data['phone_with_extension'] = phoneWithExtension;
    data['address'] = address;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (user != null) {
      data['user'] = user!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
