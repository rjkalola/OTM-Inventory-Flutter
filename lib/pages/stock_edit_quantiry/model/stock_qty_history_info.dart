import '../../otp_verification/model/user_info.dart';

class StockQtyHistoryInfo {
  int? id,stock_id;
  String? qty,created_at_formatted,note;
  UserInfo? user;

  StockQtyHistoryInfo(
      {this.id,
        this.stock_id,
        this.qty,
        this.note,
        this.created_at_formatted, this.user});

  StockQtyHistoryInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    stock_id = json['stock_id'];
    qty = json['qty'];
    note = json['note'];
    created_at_formatted = json['created_at_formatted'];
    user = json['user'] != null ? UserInfo.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['stock_id'] = stock_id;
    data['qty'] = qty;
    data['note'] = note;
    data['created_at_formatted'] = created_at_formatted;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    return data;
  }
}
