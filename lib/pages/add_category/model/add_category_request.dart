import 'dart:ffi';

import 'package:otm_inventory/web_services/response/base_response.dart';
import 'package:otm_inventory/web_services/response/module_info.dart';

class AddCategoryRequest {
  int? id;
  String? category_name;
  bool? status;

  AddCategoryRequest(
      {this.id,
      this.category_name,
      this.status,});
}
