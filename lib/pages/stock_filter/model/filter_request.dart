class FilterRequest {
  String? supplier, category, supplier_key, category_key;

  FilterRequest({
    this.supplier,
    this.category,
    this.supplier_key,
    this.category_key,
  });

  FilterRequest.fromJson(Map<String, dynamic> json) {
    supplier = json['supplier'];
    category = json['category'];
    supplier_key = json['supplier_key'];
    category_key = json['category_key'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['supplier'] = supplier;
    data['category'] = category;
    data['supplier_key'] = supplier_key;
    data['category_key'] = category_key;
    return data;
  }
}
