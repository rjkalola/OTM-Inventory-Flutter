class DashboardStockCountResponse {
  bool? isSuccess;
  String? message, data_size;
  int? inStockCount,
      lowStockCount,
      outOfStockCount,
      minusStockCount,
      issuedCount,
      receivedCount,
      partiallyReceived,
      cancelledCount;

  DashboardStockCountResponse(
      {this.isSuccess,
      this.message,
      this.data_size,
      this.inStockCount,
      this.lowStockCount,
      this.outOfStockCount,
      this.minusStockCount,
      this.issuedCount,
      this.receivedCount,
      this.partiallyReceived,
      this.cancelledCount});

  DashboardStockCountResponse.fromJson(Map<String, dynamic> json) {
    isSuccess = json['IsSuccess'];
    message = json['Message'];
    data_size = json['data_size'];
    inStockCount = json['in_stock_count'];
    lowStockCount = json['low_stock_count'];
    outOfStockCount = json['out_of_stock_count'];
    minusStockCount = json['minus_stock_count'];
    issuedCount = json['issued_count'];
    receivedCount = json['received_count'];
    partiallyReceived = json['partially_received'];
    cancelledCount = json['cancelled_count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['IsSuccess'] = isSuccess;
    data['Message'] = message;
    data['data_size'] = data_size;
    data['in_stock_count'] = inStockCount;
    data['low_stock_count'] = lowStockCount;
    data['out_of_stock_count'] = outOfStockCount;
    data['minus_stock_count'] = minusStockCount;
    data['issued_count'] = issuedCount;
    data['received_count'] = receivedCount;
    data['partially_received'] = partiallyReceived;
    data['cancelled_count'] = cancelledCount;
    return data;
  }
}
