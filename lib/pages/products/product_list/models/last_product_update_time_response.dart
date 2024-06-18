

import '../../../../web_services/response/base_response.dart';

class LastProductUpdateTimeResponse extends BaseResponse{
  String? updated_at;

  LastProductUpdateTimeResponse(
      {this.updated_at});

  LastProductUpdateTimeResponse.fromJson(Map<String, dynamic> json) {
    updated_at = json['updated_at'];
    IsSuccess = json['IsSuccess'];
    Message = json['Message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  <String, dynamic>{};
    data['updated_at'] = updated_at;
    data['IsSuccess'] = IsSuccess;
    data['Message'] = Message;
    return data;
  }
}
