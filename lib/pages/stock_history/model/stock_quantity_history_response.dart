import 'package:otm_inventory/pages/stock_edit_quantiry/model/stock_qty_history_info.dart';
import 'package:otm_inventory/web_services/response/base_response.dart';

class StockQuantityHistoryResponse extends BaseResponse {
  List<StockQtyHistoryInfo>? info;
  String? stock_qty;

  StockQuantityHistoryResponse({this.info, this.stock_qty});

  StockQuantityHistoryResponse.fromJson(Map<String, dynamic> json) {
    IsSuccess = json['IsSuccess'];
    Message = json['Message'];
    stock_qty = json['stock_qty'];
    if (json['Info'] != null) {
      info = <StockQtyHistoryInfo>[];
      json['Info'].forEach((v) {
        info!.add(StockQtyHistoryInfo.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['IsSuccess'] = IsSuccess;
    data['Message'] = Message;
    data['stock_qty'] = stock_qty;
    if (info != null) {
      data['Info'] = info!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
