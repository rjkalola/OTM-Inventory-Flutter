import 'package:otm_inventory/pages/category_list/model/category_info.dart';
import 'package:otm_inventory/web_services/response/base_response.dart';

class CategoryListResponse extends BaseResponse {
  List<CategoryInfo>? info;

  CategoryListResponse({this.info});

  CategoryListResponse.fromJson(Map<String, dynamic> json) {
    IsSuccess = json['IsSuccess'];
    Message = json['Message'];
    if (json['Info'] != null) {
      info = <CategoryInfo>[];
      json['Info'].forEach((v) {
        info!.add(CategoryInfo.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['IsSuccess'] = IsSuccess;
    data['Message'] = Message;
    if (info != null) {
      data['Info'] = info!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
