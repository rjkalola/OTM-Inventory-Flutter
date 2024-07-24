class SupplierInfo {
  int? id, phoneExtensionId, weightUnitId;
  String? contactName,
      email,
      phone,
      phoneWithExtension,
      phoneExtensionName,
      flagName,
      companyName,
      address,
      weight,
      supplierWeight,
      weightUnitName,
      account_number;
  bool? status;

  SupplierInfo(
      {this.id,
      this.phoneExtensionId,
      this.contactName,
      this.email,
      this.phone,
      this.phoneWithExtension,
      this.phoneExtensionName,
      this.flagName,
      this.companyName,
      this.address,
      this.weight,
      this.supplierWeight,
      this.weightUnitId,
      this.weightUnitName,
      this.status,
      this.account_number});

  SupplierInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    phoneExtensionId = json['phone_extension_id'];
    contactName = json['contact_name'];
    email = json['email'];
    phone = json['phone'];
    phoneExtensionName = json['phone_extension_name'];
    flagName = json['flag_name'];
    phoneWithExtension = json['phone_with_extension'];
    companyName = json['company_name'];
    address = json['address'];
    weight = json['weight'];
    supplierWeight = json['supplierWeight'];
    weightUnitId = json['weight_unit_id'];
    weightUnitName = json['weight_unit_name'];
    status = json['status'];
    account_number = json['account_number'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['phone_extension_id'] = phoneExtensionId;
    data['contact_name'] = contactName;
    data['email'] = email;
    data['phone'] = phone;
    data['phone_extension_name'] = phoneExtensionName;
    data['flag_name'] = flagName;
    data['phone_with_extension'] = phoneWithExtension;
    data['company_name'] = companyName;
    data['address'] = address;
    data['weight'] = weight;
    data['supplierWeight'] = supplierWeight;
    data['weight_unit_id'] = weightUnitId;
    data['weight_unit_name'] = weightUnitName;
    data['status'] = status;
    data['account_number'] = account_number;
    return data;
  }
}
