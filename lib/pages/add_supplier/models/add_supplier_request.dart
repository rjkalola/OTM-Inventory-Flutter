import 'dart:ffi';

import 'package:otm_inventory/web_services/response/base_response.dart';
import 'package:otm_inventory/web_services/response/module_info.dart';

class AddSupplierRequest  {
  int? id, phone_extension_id, weight_unit_id, mode_type;
  String? contact_name,
      email,
      phone,
      phone_extension,
      address,
      weight,
      company_name;
  bool? status;

  AddSupplierRequest(
      {this.id,
      this.contact_name,
      this.email,
      this.phone,
      this.phone_extension_id,
      this.phone_extension,
      this.address,
      this.weight,
      this.weight_unit_id,
      this.company_name,
      this.status,
      this.mode_type});
}
