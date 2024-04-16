import 'dart:ffi';

import 'package:otm_inventory/web_services/response/base_response.dart';
import 'package:otm_inventory/web_services/response/module_info.dart';

class AddStoreRequest extends BaseResponse {
  int? id, phone_extension_id, mode_type;
  String? store_name, phone, phone_extension, address, store_managers;
  bool? status;

  AddStoreRequest(
      {this.id,
      this.phone_extension_id,
      this.store_name,
      this.phone,
      this.phone_extension,
      this.address,
      this.store_managers,
      this.status,
      this.mode_type});
}
