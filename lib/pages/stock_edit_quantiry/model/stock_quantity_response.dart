import 'package:otm_inventory/pages/products/product_list/models/product_info.dart';
import 'package:otm_inventory/web_services/response/base_response.dart';

class StockQuantityDetailsResponse extends BaseResponse{
  ProductInfo? info;

  StockQuantityDetailsResponse({this.info});

  StockQuantityDetailsResponse.fromJson(Map<String, dynamic> json) {
    IsSuccess = json['IsSuccess'];
    Message = json['Message'];
    info = json['Info'] != null ? ProductInfo.fromJson(json['Info']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  <String, dynamic>{};
    data['IsSuccess'] = IsSuccess;
    data['Message'] = Message;
    if (info != null) {
      data['Info'] = info!.toJson();
    }
    return data;
  }
}
