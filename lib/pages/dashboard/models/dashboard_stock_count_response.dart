class DashboardStockCountResponse {
  bool? isSuccess;
  String? message, data_size;
  int? inStockCount, lowStockCount, outOfStockCount;

  DashboardStockCountResponse(
      {this.isSuccess,
      this.message,
      this.data_size,
      this.inStockCount,
      this.lowStockCount,
      this.outOfStockCount});

  DashboardStockCountResponse.fromJson(Map<String, dynamic> json) {
    isSuccess = json['IsSuccess'];
    message = json['Message'];
    data_size = json['data_size'];
    inStockCount = json['in_stock_count'];
    lowStockCount = json['low_stock_count'];
    outOfStockCount = json['out_of_stock_count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['IsSuccess'] = isSuccess;
    data['Message'] = message;
    data['data_size'] = data_size;
    data['in_stock_count'] = inStockCount;
    data['low_stock_count'] = lowStockCount;
    data['out_of_stock_count'] = outOfStockCount;
    return data;
  }
}
