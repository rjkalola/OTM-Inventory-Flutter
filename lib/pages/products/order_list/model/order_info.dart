class OrderInfo {
  int? id;
  String? orderId;
  String? weekStartDate;
  String? weekEndDate;
  int? companyId;
  int? storeId;
  String? storeName;
  int? orderedUserId;
  String? orderedUserName;
  String? orderedUserContact;
  String? orderedUserImage;
  int? teamId;
  int? projectId;
  int? projectAddressId;
  int? deliverTo;
  String? deliverOn;
  int? isPriority;
  String? totalPrice;
  String? createdAt;
  String? updatedAt;
  String? formattedWeekStartDate;
  String? formattedWeekEndDate;
  String? formattedCreatedAt;
  String? currency;
  int? totalQty;
  String? orderStatus;

  OrderInfo(
      {this.id,
      this.orderId,
      this.weekStartDate,
      this.weekEndDate,
      this.companyId,
      this.storeId,
      this.storeName,
      this.orderedUserId,
      this.orderedUserName,
      this.orderedUserContact,
      this.orderedUserImage,
      this.teamId,
      this.projectId,
      this.projectAddressId,
      this.deliverTo,
      this.deliverOn,
      this.isPriority,
      this.totalPrice,
      this.createdAt,
      this.updatedAt,
      this.formattedWeekStartDate,
      this.formattedWeekEndDate,
      this.formattedCreatedAt,
      this.currency,
      this.totalQty,
      this.orderStatus});

  OrderInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    orderId = json['order_id'];
    weekStartDate = json['week_start_date'];
    weekEndDate = json['week_end_date'];
    companyId = json['company_id'];
    storeId = json['store_id'];
    storeName = json['store_name'];
    orderedUserId = json['ordered_user_id'];
    orderedUserName = json['ordered_user_name'];
    orderedUserContact = json['ordered_user_contact'];
    orderedUserImage = json['ordered_user_image'];
    teamId = json['team_id'];
    projectId = json['project_id'];
    projectAddressId = json['project_address_id'];
    deliverTo = json['deliver_to'];
    deliverOn = json['deliver_on'];
    isPriority = json['is_priority'];
    totalPrice = json['total_price'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    formattedWeekStartDate = json['formatted_week_start_date'];
    formattedWeekEndDate = json['formatted_week_end_date'];
    formattedCreatedAt = json['formatted_created_at'];
    currency = json['currency'];
    totalQty = json['total_qty'];
    orderStatus = json['order_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['order_id'] = this.orderId;
    data['week_start_date'] = this.weekStartDate;
    data['week_end_date'] = this.weekEndDate;
    data['company_id'] = this.companyId;
    data['store_id'] = this.storeId;
    data['store_name'] = this.storeName;
    data['ordered_user_id'] = this.orderedUserId;
    data['ordered_user_name'] = this.orderedUserName;
    data['ordered_user_contact'] = this.orderedUserContact;
    data['ordered_user_image'] = this.orderedUserImage;
    data['team_id'] = this.teamId;
    data['project_id'] = this.projectId;
    data['project_address_id'] = this.projectAddressId;
    data['deliver_to'] = this.deliverTo;
    data['deliver_on'] = this.deliverOn;
    data['is_priority'] = this.isPriority;
    data['total_price'] = this.totalPrice;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['formatted_week_start_date'] = this.formattedWeekStartDate;
    data['formatted_week_end_date'] = this.formattedWeekEndDate;
    data['formatted_created_at'] = this.formattedCreatedAt;
    data['currency'] = this.currency;
    data['total_qty'] = this.totalQty;
    data['order_status'] = this.orderStatus;
    return data;
  }
}
