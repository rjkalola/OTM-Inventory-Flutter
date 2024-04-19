import 'package:otm_inventory/web_services/response/base_response.dart';
import 'package:otm_inventory/web_services/response/module_info.dart';

class ProductResourcesResponse extends BaseResponse {
  List<ModuleInfo>? categories,
      supplier,
      model,
      manufacturer,
      lengthUnit,
      weightUnit;

  ProductResourcesResponse(
      {this.categories,
      this.supplier,
      this.model,
      this.manufacturer,
      this.lengthUnit,
      this.weightUnit});

  ProductResourcesResponse.fromJson(Map<String, dynamic> json) {
    IsSuccess = json['IsSuccess'];
    Message = json['Message'];
    if (json['categories'] != null) {
      categories = <ModuleInfo>[];
      json['categories'].forEach((v) {
        categories!.add(ModuleInfo.fromJson(v));
      });
    }
    if (json['supplier'] != null) {
      supplier = <ModuleInfo>[];
      json['supplier'].forEach((v) {
        supplier!.add(ModuleInfo.fromJson(v));
      });
    }
    if (json['model'] != null) {
      model = <ModuleInfo>[];
      json['model'].forEach((v) {
        model!.add(ModuleInfo.fromJson(v));
      });
    }
    if (json['manufacturer'] != null) {
      manufacturer = <ModuleInfo>[];
      json['manufacturer'].forEach((v) {
        manufacturer!.add(ModuleInfo.fromJson(v));
      });
    }
    if (json['lengthUnit'] != null) {
      lengthUnit = <ModuleInfo>[];
      json['lengthUnit'].forEach((v) {
        lengthUnit!.add(ModuleInfo.fromJson(v));
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
    if (categories != null) {
      data['categories'] = categories!.map((v) => v.toJson()).toList();
    }
    if (supplier != null) {
      data['supplier'] = supplier!.map((v) => v.toJson()).toList();
    }
    if (model != null) {
      data['model'] = model!.map((v) => v.toJson()).toList();
    }
    if (manufacturer != null) {
      data['manufacturer'] = manufacturer!.map((v) => v.toJson()).toList();
    }
    if (lengthUnit != null) {
      data['lengthUnit'] = lengthUnit!.map((v) => v.toJson()).toList();
    }
    if (weightUnit != null) {
      data['weightUnit'] = weightUnit!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
