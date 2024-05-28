class FilterInfo {
  int? id;
  String? name;
  bool? check;
  List<FilterInfo>? data;

  FilterInfo({this.id, this.name, this.data,this.check});

  FilterInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    if (json['data'] != null) {
      data = <FilterInfo>[];
      json['data'].forEach((v) {
        data!.add(FilterInfo.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}