

import '../../../../web_services/response/base_response.dart';

class LastProductUpdateTimeResponse extends BaseResponse{
  String? created_at;

  LastProductUpdateTimeResponse(
      {this.created_at});

  LastProductUpdateTimeResponse.fromJson(Map<String, dynamic> json) {
    created_at = json['created_at'];
    IsSuccess = json['IsSuccess'];
    Message = json['Message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  <String, dynamic>{};
    data['created_at'] = created_at;
    data['IsSuccess'] = IsSuccess;
    data['Message'] = Message;
    return data;
  }
}
