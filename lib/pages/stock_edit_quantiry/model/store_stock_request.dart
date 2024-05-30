

class StockStoreRequest {
  String? store_id, product_id, qty, user_id, note, mode;

  StockStoreRequest({
    this.store_id,
    this.product_id,
    this.qty,
    this.user_id,
    this.note,
    this.mode,
  });

  StockStoreRequest.fromJson(Map<String, dynamic> json) {
    store_id = json['store_id'];
    product_id = json['product_id'];
    qty = json['qty'];
    user_id = json['user_id'];
    note = json['note'];
    mode = json['mode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['store_id'] = store_id;
    data['product_id'] = product_id;
    data['qty'] = qty;
    data['user_id'] = user_id;
    data['note'] = note;
    data['mode'] = mode;
    return data;
  }
}
