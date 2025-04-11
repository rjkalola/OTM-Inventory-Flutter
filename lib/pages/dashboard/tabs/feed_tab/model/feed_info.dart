class FeedInfo {
  int? id;
  int? fromUserId;
  int? userId;
  String? userIdEnc;
  String? profileIdEnc;
  int? companyId;
  int? status;
  int? fireDoorInstallationId;
  int? fireStoppingInstallationId;
  int? feedType;
  String? message;
  int? teamId;
  int? profileId;
  String? name;
  String? profileName;
  String? image;
  String? imageMain;
  String? createdDate;
  String? requestDate;
  String? note;
  int? applyAgainButton;
  String? weekStartDate;

  FeedInfo(
      {this.id,
      this.fromUserId,
      this.userId,
      this.userIdEnc,
      this.profileIdEnc,
      this.companyId,
      this.status,
      this.fireDoorInstallationId,
      this.fireStoppingInstallationId,
      this.feedType,
      this.message,
      this.teamId,
      this.profileId,
      this.name,
      this.profileName,
      this.image,
      this.imageMain,
      this.createdDate,
      this.requestDate,
      this.note,
      this.applyAgainButton,
      this.weekStartDate});

  FeedInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fromUserId = json['from_user_id'];
    userId = json['user_id'];
    userIdEnc = json['user_id_enc'];
    profileIdEnc = json['profile_id_enc'];
    companyId = json['company_id'];
    status = json['status'];
    fireDoorInstallationId = json['fire_door_installation_id'];
    fireStoppingInstallationId = json['fire_stopping_installation_id'];
    feedType = json['feed_type'];
    message = json['message'];
    teamId = json['team_id'];
    profileId = json['profile_id'];
    name = json['name'];
    profileName = json['profile_name'];
    image = json['image'];
    imageMain = json['image_main'];
    createdDate = json['created_date'];
    requestDate = json['request_date'];
    note = json['note'];
    applyAgainButton = json['apply_again_button'];
    weekStartDate = json['week_start_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['from_user_id'] = this.fromUserId;
    data['user_id'] = this.userId;
    data['user_id_enc'] = this.userIdEnc;
    data['profile_id_enc'] = this.profileIdEnc;
    data['company_id'] = this.companyId;
    data['status'] = this.status;
    data['fire_door_installation_id'] = this.fireDoorInstallationId;
    data['fire_stopping_installation_id'] = this.fireStoppingInstallationId;
    data['feed_type'] = this.feedType;
    data['message'] = this.message;
    data['team_id'] = this.teamId;
    data['profile_id'] = this.profileId;
    data['name'] = this.name;
    data['profile_name'] = this.profileName;
    data['image'] = this.image;
    data['image_main'] = this.imageMain;
    data['created_date'] = this.createdDate;
    data['request_date'] = this.requestDate;
    data['note'] = this.note;
    data['apply_again_button'] = this.applyAgainButton;
    data['week_start_date'] = this.weekStartDate;
    return data;
  }
}
