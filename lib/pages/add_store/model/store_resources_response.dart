import 'package:otm_inventory/web_services/response/base_response.dart';
import 'package:otm_inventory/web_services/response/module_info.dart';

class StoreResourcesResponse extends BaseResponse {
  List<ModuleInfo>? countries,
      weightUnit,
      users;

  StoreResourcesResponse(
      {this.countries,
      this.weightUnit,
      this.users});

  StoreResourcesResponse.fromJson(Map<String, dynamic> json) {
    IsSuccess = json['IsSuccess'];
    Message = json['Message'];
    if (json['countries'] != null) {
      countries = <ModuleInfo>[];
      json['countries'].forEach((v) {
        countries!.add(ModuleInfo.fromJson(v));
      });
    }
    if (json['weightUnit'] != null) {
      weightUnit = <ModuleInfo>[];
      json['weightUnit'].forEach((v) {
        weightUnit!.add(ModuleInfo.fromJson(v));
      });
    }
    if (json['users'] != null) {
      users = <ModuleInfo>[];
      json['users'].forEach((v) {
        users!.add(ModuleInfo.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['IsSuccess'] = IsSuccess;
    data['Message'] = Message;
    if (countries != null) {
      data['countries'] = countries!.map((v) => v.toJson()).toList();
    }
    if (weightUnit != null) {
      data['weightUnit'] = weightUnit!.map((v) => v.toJson()).toList();
    }
    if (users != null) {
      data['users'] = users!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
