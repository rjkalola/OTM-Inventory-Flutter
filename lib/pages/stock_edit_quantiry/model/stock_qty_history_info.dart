class StockQtyHistoryInfo {
  int? id,stock_id;
  String? qty,created_at_formatted;

  StockQtyHistoryInfo(
      {this.id,
        this.stock_id,
        this.qty,
        this.created_at_formatted});

  StockQtyHistoryInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    stock_id = json['stock_id'];
    qty = json['qty'];
    created_at_formatted = json['created_at_formatted'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['stock_id'] = stock_id;
    data['qty'] = qty;
    data['created_at_formatted'] = created_at_formatted;
    return data;
  }
}
