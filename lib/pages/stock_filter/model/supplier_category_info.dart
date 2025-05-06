class SupplierCategoryInfo {
  int? supplierId;
  List<int>? categoryIds;

  SupplierCategoryInfo({this.supplierId, this.categoryIds});

  SupplierCategoryInfo.fromJson(Map<String, dynamic> json) {
    supplierId = json['supplierId'];
    if (json['categoryIds'] != null) {
      json['categoryIds'].forEach((v) {
        categoryIds!.add(v);
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['supplierId'] = supplierId;
    if (this.categoryIds != null) {
      data['categoryIds'] = this.categoryIds!.map((v) => v).toList();
    }
    return data;
  }
}