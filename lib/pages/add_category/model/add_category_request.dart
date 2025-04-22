import 'dart:ffi';

import 'package:otm_inventory/web_services/response/base_response.dart';
import 'package:otm_inventory/web_services/response/module_info.dart';

class AddCategoryRequest {
  int? id, parent_category_id;
  String? category_name, image_url, image_thumb_url, pc_name;
  bool? status;

  AddCategoryRequest({
    this.id,
    this.category_name,
    this.parent_category_id,
    this.pc_name,
    this.image_url,
    this.image_thumb_url,
    this.status,
  });
}
