import '../../otp_verification/model/user_info.dart';

class StockQtyHistoryInfo {
  int? id, stock_id;
  String? qty, created_at_formatted, reference, currencyPrice, date, price;
  UserInfo? user;

  StockQtyHistoryInfo(
      {this.id,
      this.stock_id,
      this.qty,
      this.reference,
      this.created_at_formatted,
      this.currencyPrice,
      this.price,
      this.date,
      this.user});

  StockQtyHistoryInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    stock_id = json['stock_id'];
    qty = json['qty'];
    reference = json['reference'];
    created_at_formatted = json['created_at_formatted'];
    currencyPrice = json['currencyPrice'];
    price = json['price'];
    date = json['date'];
    user = json['user'] != null ? UserInfo.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['stock_id'] = stock_id;
    data['qty'] = qty;
    data['reference'] = reference;
    data['created_at_formatted'] = created_at_formatted;
    data['currencyPrice'] = currencyPrice;
    data['price'] = price;
    data['date'] = date;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    return data;
  }
}
