

import '../../../../web_services/response/base_response.dart';
import 'product_info.dart';

class ProductListResponse extends BaseResponse{
  List<ProductInfo>? info;
  int? total;
  int? offset;

  ProductListResponse(
      {this.info, this.total, this.offset});

  ProductListResponse.fromJson(Map<String, dynamic> json) {
    if (json['info'] != null) {
      info = <ProductInfo>[];
      json['info'].forEach((v) {
        info!.add(ProductInfo.fromJson(v));
      });
    }
    total = json['total'];
    offset = json['offset'];
    IsSuccess = json['IsSuccess'];
    Message = json['Message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  <String, dynamic>{};
    if (info != null) {
      data['info'] = info!.map((v) => v.toJson()).toList();
    }
    data['total'] = total;
    data['offset'] = offset;
    data['IsSuccess'] = IsSuccess;
    data['Message'] = Message;
    return data;
  }
}
