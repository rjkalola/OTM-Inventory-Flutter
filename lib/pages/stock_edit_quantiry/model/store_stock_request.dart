

class StockStoreRequest {
  String? store_id, product_id, qty, user_id, note,date_time, mode;

  StockStoreRequest({
    this.store_id,
    this.product_id,
    this.qty,
    this.user_id,
    this.note,
    this.date_time,
    this.mode,
  });

  StockStoreRequest.fromJson(Map<String, dynamic> json) {
    store_id = json['store_id'];
    product_id = json['product_id'];
    qty = json['qty'];
    user_id = json['user_id'];
    note = json['note'];
    date_time = json['date_time'];
    mode = json['mode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['store_id'] = store_id;
    data['product_id'] = product_id;
    data['qty'] = qty;
    data['user_id'] = user_id;
    data['note'] = note;
    data['date_time'] = date_time;
    data['mode'] = mode;
    return data;
  }
}
