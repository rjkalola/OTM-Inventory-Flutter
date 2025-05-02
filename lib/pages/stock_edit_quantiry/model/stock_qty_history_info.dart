import '../../otp_verification/model/user_info.dart';

class StockQtyHistoryInfo {
  int? id, stock_id;
  String? qty,
      old_qty,
      sub_qty,
      pack_off_unit_name,
      created_at_formatted,
      reference,
      currencyPrice,
      date,
      price;
  UserInfo? user;

  StockQtyHistoryInfo(
      {this.id,
      this.stock_id,
      this.qty,
      this.old_qty,
      this.sub_qty,
      this.pack_off_unit_name,
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
    sub_qty = json['sub_qty'];
    pack_off_unit_name = json['pack_off_unit_name'];
    old_qty = json['old_qty'];
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
    data['old_qty'] = old_qty;
    data['sub_qty'] = sub_qty;
    data['pack_off_unit_name'] = pack_off_unit_name;
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
