import 'package:otm_inventory/web_services/response/base_response.dart';
import 'package:otm_inventory/web_services/response/module_info.dart';

class SupplierResourcesResponse extends BaseResponse {
  List<ModuleInfo>? countries,
      weightUnit;

  SupplierResourcesResponse(
      {this.countries,
      this.weightUnit});

  SupplierResourcesResponse.fromJson(Map<String, dynamic> json) {
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
    return data;
  }
}
