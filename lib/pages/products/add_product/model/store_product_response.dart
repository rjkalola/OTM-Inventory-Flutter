import 'package:otm_inventory/pages/products/product_list/models/product_info.dart';
import 'package:otm_inventory/web_services/response/base_response.dart';

class StoreProductResponse extends BaseResponse{
  int? id;

  StoreProductResponse({this.id});

  StoreProductResponse.fromJson(Map<String, dynamic> json) {
    IsSuccess = json['IsSuccess'];
    Message = json['Message'];
    id = json['info']['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  <String, dynamic>{};
    data['IsSuccess'] = IsSuccess;
    data['Message'] = Message;
    data['info']['id'] = id;
    return data;
  }
}
