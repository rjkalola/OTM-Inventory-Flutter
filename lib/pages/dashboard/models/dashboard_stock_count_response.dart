class DashboardStockCountResponse {
  bool? isSuccess;
  String? message, inStockCount, lowStockCount, outOfStockCount;

  DashboardStockCountResponse(
      {this.isSuccess,
      this.message,
      this.inStockCount,
      this.lowStockCount,
      this.outOfStockCount});

  DashboardStockCountResponse.fromJson(Map<String, dynamic> json) {
    isSuccess = json['IsSuccess'];
    message = json['Message'];
    inStockCount = json['in_stock_count'];
    lowStockCount = json['low_stock_count'];
    outOfStockCount = json['out_of_stock_count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['IsSuccess'] = isSuccess;
    data['Message'] = message;
    data['in_stock_count'] = inStockCount;
    data['low_stock_count'] = lowStockCount;
    data['out_of_stock_count'] = outOfStockCount;
    return data;
  }
}
