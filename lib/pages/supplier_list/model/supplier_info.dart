class SupplierInfo {
  int? id,phoneExtensionId;
  String? contactName,email,phone,phoneWithExtension,companyName,address,weight,weightUnitId,supplierWeight;
  bool? status;

  SupplierInfo(
      {this.id,
        this.phoneExtensionId,
        this.contactName,
        this.email,
        this.phone,
        this.phoneWithExtension,
        this.companyName,
        this.address,
        this.weight,
        this.supplierWeight,
        this.weightUnitId,
        this.status,});

  SupplierInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    phoneExtensionId = json['phone_extension_id'];
    contactName = json['contact_name'];
    email = json['email'];
    phone = json['phone'];
    phoneWithExtension = json['phone_with_extension'];
    companyName = json['company_name'];
    address = json['address'];
    weight = json['weight'];
    supplierWeight = json['supplierWeight'];
    weightUnitId = json['weight_unit_id'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  <String, dynamic>{};
    data['id'] = id;
    data['phone_extension_id'] = phoneExtensionId;
    data['contact_name'] = contactName;
    data['email'] = email;
    data['phone'] = phone;
    data['phone_with_extension'] = phoneWithExtension;
    data['company_name'] = companyName;
    data['address'] = address;
    data['weight'] = weight;
    data['supplierWeight'] = supplierWeight;
    data['weight_unit_id'] = weightUnitId;
    data['status'] = status;
    return data;
  }
}
