// To parse this JSON data, do
//
//     final companyModel = companyModelFromJson(jsonString);

import 'dart:convert';

CompanyModel companyModelFromJson(String str) => CompanyModel.fromJson(json.decode(str));

String companyModelToJson(CompanyModel data) => json.encode(data.toJson());

class CompanyModel {
  CompanyModel({
    this.session,
    this.clientId,
    this.profileSlug,
    this.clientSettings,
    this.categoryName,
    this.currentPage,
    this.version,
    this.address,
    this.profileStats,
    this.movieDetails,
    this.wc,
  });

  List<dynamic>? session;
  String? clientId;
  String? profileSlug;
  ClientSettings? clientSettings;
  String? categoryName;
  String? currentPage;
  int? version;
  Address? address;
  ProfileStats? profileStats;
  dynamic movieDetails;
  int? wc;

  factory CompanyModel.fromJson(Map<String, dynamic> json) => CompanyModel(

    session: json["session"] == null ? null : List<dynamic>.from(json["session"].map((x) => x)),
    clientId: json["client_id"],
    profileSlug: json["profile_slug"],
    clientSettings: json["clientSettings"] == null ? null : ClientSettings.fromJson(json["clientSettings"]),
    categoryName: json["category_name"],
    currentPage: json["current_page"],
    version: json["version"],
    address: json["address"] == null ? null : Address.fromJson(json["address"]),
    profileStats: json["profileStats"] == null ? null : ProfileStats.fromJson(json["profileStats"]),
    // movieDetails: json["movieDetails"] == null ? null : List<dynamic>.from(json["movieDetails"].map((x) => x)),
    movieDetails: json["movieDetails"],
    wc: json["wc"],
  );

  Map<String, dynamic> toJson() => {
    "session": session == null ? null : List<dynamic>.from(session!.map((x) => x)),
    "client_id": clientId,
    "profile_slug": profileSlug,
    "clientSettings": clientSettings == null ? null : clientSettings!.toJson(),
    "category_name": categoryName,
    "current_page": currentPage,
    "version": version,
    "address": address == null ? null : address!.toJson(),
    "profileStats": profileStats == null ? null : profileStats!.toJson(),
    "movieDetails": movieDetails == null ? null : List<dynamic>.from(movieDetails!.map((x) => x)),
    "wc": wc,
  };

  String shareLink(String slug) {
    return "https://www.thereviewclip.com/profile/$slug";
  }
}

class Address {
  Address({
    this.address,
    this.state,
    this.city,
    this.location,
    this.zip,
    this.mobile,
    this.country,
    this.phone,
    this.websiteUrl,
  });

  String? address;
  String? state;
  String? city;
  String? location;
  String? zip;
  String? mobile;
  String? country;
  String? phone;
  String? websiteUrl;

  factory Address.fromJson(Map<String, dynamic> json) => Address(
    address: json["address"],
    state: json["state"],
    city: json["city"],
    location: json["location"],
    zip: json["zip"],
    mobile: json["mobile"],
    country: json["country"],
    phone: json["phone"],
    websiteUrl: json["website_url"],
  );

  Map<String, dynamic> toJson() => {
    "address": address,
    "state": state,
    "city": city,
    "location": location,
    "zip": zip,
    "mobile": mobile,
    "country": country,
    "phone": phone,
    "website_url": websiteUrl,
  };
}

class ClientSettings {
  ClientSettings({
    this.clientId,
    this.publicReviewEnabled,
    this.showTagLine,
    this.makeVideosPrivate,
  });

  String? clientId;
  String? publicReviewEnabled;
  String? showTagLine;
  String? makeVideosPrivate;

  factory ClientSettings.fromJson(Map<String, dynamic> json) => ClientSettings(
    clientId: json["client_id"],
    publicReviewEnabled: json["public_review_enabled"],
    showTagLine: json["showTagLine"],
    makeVideosPrivate: json["makeVideosPrivate"],
  );

  Map<String, dynamic> toJson() => {
    "client_id": clientId,
    "public_review_enabled": publicReviewEnabled,
    "showTagLine": showTagLine,
    "makeVideosPrivate": makeVideosPrivate,
  };
}

class ProfileStats {
  ProfileStats({
    this.createdOn,
    this.displayName,
    this.rating,
    this.totalVideos,
    this.replays,
    this.avatar,
    this.bannerImg,
    this.commentCount,
    this.tag,
    this.tagAvai,
    this.promoVideo,
    this.category,
  });

  String? createdOn;
  String? displayName;
  int? rating;
  int? totalVideos;
  int? replays;
  String? avatar;
  String? bannerImg;
  String? commentCount;
  String? tag;
  int? tagAvai;
  String? promoVideo;
  int? category;

  factory ProfileStats.fromJson(Map<String, dynamic> json) => ProfileStats(
    createdOn: json["createdOn"],
    displayName: json["display_name"],
    rating: json["rating"],
    totalVideos: json["total_videos"],
    replays: json["replays"],
    avatar: json["avatar"],
    bannerImg: json["banner_img"],
    commentCount: json["comment_count"],
    tag: json["tag"],
    tagAvai: json["tagAvai"],
    promoVideo: json["promo_video"],
    category: json["category"],
  );

  Map<String, dynamic> toJson() => {
    "createdOn": createdOn,
    "display_name": displayName,
    "rating": rating,
    "total_videos": totalVideos,
    "replays": replays,
    "avatar": avatar,
    "banner_img": bannerImg,
    "comment_count": commentCount,
    "tag": tag,
    "tagAvai": tagAvai,
    "promo_video": promoVideo,
    "category": category,
  };
}
