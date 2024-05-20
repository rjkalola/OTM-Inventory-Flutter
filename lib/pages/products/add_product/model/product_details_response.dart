import 'package:otm_inventory/web_services/response/base_response.dart';

import '../../product_list/models/product_info.dart';

class ProductDetailsResponse extends BaseResponse {
  ProductInfo? info;

  ProductDetailsResponse({this.info});

  ProductDetailsResponse.fromJson(Map<String, dynamic> json) {
    IsSuccess = json['IsSuccess'];
    Message = json['Message'];
    info = json['Info'] != null ? ProductInfo.fromJson(json['Info']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['IsSuccess'] = IsSuccess;
    data['Message'] = Message;
    if (info != null) {
      data['Info'] = info!.toJson();
    }
    return data;
  }
}
