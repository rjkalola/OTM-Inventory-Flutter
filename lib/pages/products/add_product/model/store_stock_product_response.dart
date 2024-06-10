import 'package:otm_inventory/web_services/response/base_response.dart';

class StoreStockProductResponse extends BaseResponse{
  ItemInfo? info;

  StoreStockProductResponse({this.info});

  StoreStockProductResponse.fromJson(Map<String, dynamic> json) {
    IsSuccess = json['IsSuccess'];
    Message = json['Message'];
    info = json['product'] != null ? ItemInfo.fromJson(json['product']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  <String, dynamic>{};
    data['IsSuccess'] = IsSuccess;
    data['Message'] = Message;
    if (info != null) {
      data['product'] = info!.toJson();
    }
    return data;
  }
}

class ItemInfo {
  int? id;

  ItemInfo(
      {this.id,
      });

  ItemInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  <String, dynamic>{};
    data['id'] = id;
    return data;
  }
}
