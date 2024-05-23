class FilterRequest {
  String? supplier,category;

  FilterRequest(
      {this.supplier,
        this.category,});

  FilterRequest.fromJson(Map<String, dynamic> json) {
    supplier = json['supplier'];
    category = json['category'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['supplier'] = supplier;
    data['category'] = category;
    return data;
  }
}
