// To parse this JSON data, do
//
//     final reviewerProfileModel = reviewerProfileModelFromJson(jsonString);

import 'dart:convert';

ReviewerProfileModel reviewerProfileModelFromJson(String str) => ReviewerProfileModel.fromJson(json.decode(str));

String reviewerProfileModelToJson(ReviewerProfileModel data) => json.encode(data.toJson());

class ReviewerProfileModel {
  ReviewerProfileModel({
    this.id,
    this.currentPage,
    this.version,
    this.profileStats,
    this.reviewerId,
    this.subscribers,
    this.subscribe,
    this.avatar,
    this.bannerImg,
    this.wc,
  });

  String? id;
  String? currentPage;
  int? version;
  ProfileStats? profileStats;
  String? reviewerId;
  List<Subscriber>? subscribers;
  dynamic subscribe;
  String? avatar;
  String? bannerImg;
  int? wc;

  factory ReviewerProfileModel.fromJson(Map<String, dynamic> json) => ReviewerProfileModel(
    id: json["id"],
    currentPage: json["current_page"],
    version: json["version"],
    profileStats: json["profileStats"] == null ? null : ProfileStats.fromJson(json["profileStats"]),
    reviewerId: json["reviewerId"],
    subscribers: json["subscribers"] == null ? null : List<Subscriber>.from(json["subscribers"].map((x) => Subscriber.fromJson(x))),
    subscribe: json["subscribe"],
    avatar: json["avatar"],
    bannerImg: json["banner_img"],
    wc: json["wc"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "current_page": currentPage,
    "version": version,
    "profileStats": profileStats == null ? null : profileStats!.toJson(),
    "reviewerId": reviewerId,
    "subscribers": subscribers == null ? null : List<dynamic>.from(subscribers!.map((x) => x.toJson())),
    "subscribe": subscribe,
    "avatar": avatar,
    "banner_img": bannerImg,
    "wc": wc,
  };
}

class ProfileStats {
  ProfileStats({
    this.createdOn,
    this.displayName,
    this.chanel,
    this.location,
    this.mobile,
    this.totalVideos,
    this.avatar,
    this.about,
    this.replays,
    this.createdDate,
  });

  String? createdOn;
  String? displayName;
  String? chanel;
  String? location;
  String? mobile;
  int? totalVideos;
  String? avatar;
  String? about;
  String? replays;
  String? createdDate;

  factory ProfileStats.fromJson(Map<String, dynamic> json) => ProfileStats(
    createdOn: json["createdOn"],
    displayName: json["display_name"],
    chanel: json["chanel"],
    location: json["location"],
    mobile: json["mobile"],
    totalVideos: json["total_videos"],
    avatar: json["avatar"],
    about: json["about"],
    replays: json["replays"],
    createdDate: json["created_date"],
  );

  Map<String, dynamic> toJson() => {
    "createdOn": createdOn,
    "display_name": displayName,
    "chanel": chanel,
    "location": location,
    "mobile": mobile,
    "total_videos": totalVideos,
    "avatar": avatar,
    "about": about,
    "replays": replays,
    "created_date": createdDate,
  };
}

class Subscriber {
  Subscriber({
    this.id,
    this.reviewerId,
    this.subscriberId,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.createdIp,
    this.updatedIp,
  });

  String? id;
  String? reviewerId;
  String? subscriberId;
  String? status;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? createdIp;
  String? updatedIp;

  factory Subscriber.fromJson(Map<String, dynamic> json) => Subscriber(
    id: json["id"],
    reviewerId: json["reviewer_id"],
    subscriberId: json["subscriber_id"],
    status: json["status"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    createdIp: json["created_ip"],
    updatedIp: json["updated_ip"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "reviewer_id": reviewerId,
    "subscriber_id": subscriberId,
    "status": status,
    "created_at": createdAt == null ? null : createdAt!.toIso8601String(),
    "updated_at": updatedAt == null ? null : updatedAt!.toIso8601String(),
    "created_ip": createdIp,
    "updated_ip": updatedIp,
  };
}
