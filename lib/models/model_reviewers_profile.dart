// To parse this JSON data, do
//
//     final reviewersHome = reviewersHomeFromJson(jsonString);

import 'dart:convert';

ReviewersProfile reviewersProfileFromJson(String str) => ReviewersProfile.fromJson(json.decode(str));

String reviewersProfileToJson(ReviewersProfile data) => json.encode(data.toJson());

class ReviewersProfile {
  ReviewersProfile({
    this.status,
    this.msg,
    this.data,
  });

  int? status;
  String? msg;
  List<ReviewerProfile>? data;

  factory ReviewersProfile.fromJson(Map<String, dynamic> json) => ReviewersProfile(
    status: json["status"],
    msg: json["msg"],
    data: List<ReviewerProfile>.from(json["data"].map((x) => ReviewerProfile.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "msg": msg,
    "data": List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class ReviewerProfile {
  ReviewerProfile({
    this.id,
    this.name,
    this.ch,
    this.slug,
    this.about,
    this.location,
    this.avatar,
    this.createdAt,
    this.videoCount,
    this.videoViews,
    this.videoLikes,
    this.subscribers,
  });

  int? id;
  String? name;
  String? ch;
  String? slug;
  String? about;
  String? location;
  String? avatar;
  String? createdAt;
  String? videoCount;
  String? videoViews;
  String? videoLikes;
  int? subscribers;

  factory ReviewerProfile.fromJson(Map<String, dynamic> json) => ReviewerProfile(
    id: json["id"],
    name: json["name"],
    ch: json["ch"],
    slug: json["slug"],
    about: json["about"],
    location: json["location"],
    avatar: json["avatar"],
    createdAt: json["created_at"],
    videoCount: json["video_count"],
    videoViews: json["video_views"],
    videoLikes: json["video_likes"],
    subscribers: json["subscribers"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "ch": ch,
    "slug": slug,
    "about": about,
    "location": location,
    "avatar": avatar,
    "created_at": createdAt,
    "video_count": videoCount,
    "video_views": videoViews,
    "video_likes": videoLikes,
    "subscribers": subscribers,
  };
}


