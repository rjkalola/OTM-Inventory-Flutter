import 'package:otm_inventory/pages/store_list/model/store_info.dart';
import 'package:otm_inventory/web_services/response/base_response.dart';

class StoreListResponse extends BaseResponse {
  List<StoreInfo>? info;

  StoreListResponse({this.info});

  StoreListResponse.fromJson(Map<String, dynamic> json) {
    IsSuccess = json['IsSuccess'];
    Message = json['Message'];
    if (json['Info'] != null) {
      info = <StoreInfo>[];
      json['Info'].forEach((v) {
        info!.add(StoreInfo.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['IsSuccess'] = IsSuccess;
    data['Message'] = Message;
    if (info != null) {
      data['Info'] = info!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
