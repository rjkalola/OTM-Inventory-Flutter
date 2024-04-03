class BaseResponse {
  String? IsSuccess, Message, ErrorCode;

  BaseResponse({this.IsSuccess, this.Message, this.ErrorCode});

  BaseResponse.fromJson(Map<String, dynamic> json) {
    IsSuccess = json['IsSuccess'];
    Message = json['Message'];
    ErrorCode = json['ErrorCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['IsSuccess'] = this.IsSuccess;
    data['Message'] = this.Message;
    data['ErrorCode'] = this.ErrorCode;
    return data;
  }
}

