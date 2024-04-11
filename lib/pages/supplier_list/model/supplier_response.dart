import 'package:otm_inventory/pages/supplier_list/model/supplier_info.dart';
import 'package:otm_inventory/web_services/response/base_response.dart';

class SupplierListResponse extends BaseResponse{
  List<SupplierInfo>? info;

  SupplierListResponse({this.info});

  SupplierListResponse.fromJson(Map<String, dynamic> json) {
    IsSuccess = json['IsSuccess'];
    Message = json['Message'];
    if (json['Info'] != null) {
      info = <SupplierInfo>[];
      json['Info'].forEach((v) {
        info!.add(SupplierInfo.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  <String, dynamic>{};
    data['IsSuccess'] = IsSuccess;
    data['Message'] = Message;
    if (info != null) {
      data['Info'] = info!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

