import 'package:otm_inventory/pages/dashboard/tabs/feed_tab/model/feed_info.dart';

class FeedListResponse {
  bool? isSuccess;
  String? message;
  int? offset;
  List<FeedInfo>? info;
  int? pendingRequestCount;
  int? companyFeed;
  String? latestFeedTime;

  FeedListResponse(
      {this.isSuccess,
      this.message,
      this.offset,
      this.info,
      this.pendingRequestCount,
      this.companyFeed,
      this.latestFeedTime});

  FeedListResponse.fromJson(Map<String, dynamic> json) {
    isSuccess = json['IsSuccess'];
    message = json['Message'];
    offset = json['offset'];
    if (json['info'] != null) {
      info = <FeedInfo>[];
      json['info'].forEach((v) {
        info!.add(new FeedInfo.fromJson(v));
      });
    }
    pendingRequestCount = json['pending_request_count'];
    companyFeed = json['company_feed'];
    latestFeedTime = json['latest_feed_time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['IsSuccess'] = this.isSuccess;
    data['Message'] = this.message;
    data['offset'] = this.offset;
    if (this.info != null) {
      data['info'] = this.info!.map((v) => v.toJson()).toList();
    }
    data['pending_request_count'] = this.pendingRequestCount;
    data['company_feed'] = this.companyFeed;
    data['latest_feed_time'] = this.latestFeedTime;
    return data;
  }
}
