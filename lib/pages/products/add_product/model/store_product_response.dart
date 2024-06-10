import 'package:otm_inventory/pages/products/product_list/models/product_info.dart';
import 'package:otm_inventory/web_services/response/base_response.dart';

class StoreProductResponse extends BaseResponse {
  ProductInfo? info;

  StoreProductResponse({this.info});

  StoreProductResponse.fromJson(Map<String, dynamic> json) {
    IsSuccess = json['IsSuccess'];
    Message = json['Message'];
    info =
        json['product'] != null ? ProductInfo.fromJson(json['product']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['IsSuccess'] = IsSuccess;
    data['Message'] = Message;
    if (info != null) {
      data['product'] = info!.toJson();
    }
    return data;
  }
}
