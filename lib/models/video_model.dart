// To parse this JSON data, do
//
//     final videoModel = videoModelFromJson(jsonString);

import 'dart:convert';

VideoModel videoModelFromJson(String str) => VideoModel.fromJson(json.decode(str));

String videoModelToJson(VideoModel data) => json.encode(data.toJson());

class VideoModel {
  VideoModel({
    this.v,
    this.chanel,
    this.reports,
    this.comments,
    this.session,
    this.version,
    this.currentPage,
    this.clientId,
  });

  V? v;
  Channel? chanel;
  List<dynamic>? reports;
  List<dynamic>? comments;
  dynamic session;
  int? version;
  String? currentPage;
  int? clientId;

  factory VideoModel.fromJson(Map<String, dynamic> json) => VideoModel(
    v: json["v"] == null ? null : V.fromJson(json["v"]),
    chanel: json["chanel"] == null ? null : Channel.fromJson(json["chanel"]),
    reports: json["reports"] == null ? null : List<dynamic>.from(json["reports"].map((x) => x)),
    comments: json["comments"] == null ? null : List<dynamic>.from(json["comments"].map((x) => x)),
    session: json["session"],
    version: json["version"] == null ? null : json["version"],
    currentPage: json["current_page"] == null ? null : json["current_page"],
    clientId: json["client_id"] == null ? null : json["client_id"],
  );

  Map<String, dynamic> toJson() => {
    "v": v == null ? null : v!.toJson(),
    "chanel": chanel == null ? null : chanel!.toJson(),
    "reports": reports == null ? null : List<dynamic>.from(reports!.map((x) => x)),
    "comments": comments == null ? null : List<dynamic>.from(comments!.map((x) => x)),
    "session": session,
    "version": version == null ? null : version,
    "current_page": currentPage == null ? null : currentPage,
    "client_id": clientId == null ? null : clientId,
  };
}

class Channel {
  Channel({
    this.id,
    this.name,
    this.chanel,
    this.isChannel,
    this.slug,
    this.email,
    this.about,
    this.emailActivationCode,
    this.emailActivationStatus,
    this.passwordCode,
    this.passwordCodeStatus,
    this.emailActivationAt,
    this.mobile,
    this.password,
    this.location,
    this.avatar,
    this.bannerImg,
    this.createdAt,
    this.updatedAt,
    this.createdIp,
    this.updatedIp,
    this.status,
  });

  String? id;
  String? name;
  String? chanel;
  String? isChannel;
  String? slug;
  String? email;
  String? about;
  String? emailActivationCode;
  String? emailActivationStatus;
  String? passwordCode;
  String? passwordCodeStatus;
  String? emailActivationAt;
  String? mobile;
  String? password;
  String? location;
  String? avatar;
  String? bannerImg;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? createdIp;
  String? updatedIp;
  String? status;

  factory Channel.fromJson(Map<String, dynamic> json) => Channel(
    id: json["id"] == null ? null : json["id"],
    name: json["name"] == null ? null : json["name"],
    chanel: json["chanel"] == null ? null : json["chanel"],
    isChannel: json["is_channel"] == null ? null : json["is_channel"],
    slug: json["slug"] == null ? null : json["slug"],
    email: json["email"] == null ? null : json["email"],
    about: json["about"] == null ? null : json["about"],
    emailActivationCode: json["email_activation_code"] == null ? null : json["email_activation_code"],
    emailActivationStatus: json["email_activation_status"] == null ? null : json["email_activation_status"],
    passwordCode: json["password_code"] == null ? null : json["password_code"],
    passwordCodeStatus: json["password_code_status"] == null ? null : json["password_code_status"],
    emailActivationAt: json["email_activation_at"] == null ? null : json["email_activation_at"],
    mobile: json["mobile"] == null ? null : json["mobile"],
    password: json["password"] == null ? null : json["password"],
    location: json["location"] == null ? null : json["location"],
    avatar: json["avatar"] == null ? null : json["avatar"],
    bannerImg: json["banner_img"] == null ? null : json["banner_img"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    createdIp: json["created_ip"] == null ? null : json["created_ip"],
    updatedIp: json["updated_ip"] == null ? null : json["updated_ip"],
    status: json["status"] == null ? null : json["status"],
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "name": name == null ? null : name,
    "chanel": chanel == null ? null : chanel,
    "is_channel": isChannel == null ? null : isChannel,
    "slug": slug == null ? null : slug,
    "email": email == null ? null : email,
    "about": about == null ? null : about,
    "email_activation_code": emailActivationCode == null ? null : emailActivationCode,
    "email_activation_status": emailActivationStatus == null ? null : emailActivationStatus,
    "password_code": passwordCode == null ? null : passwordCode,
    "password_code_status": passwordCodeStatus == null ? null : passwordCodeStatus,
    "email_activation_at": emailActivationAt == null ? null : emailActivationAt,
    "mobile": mobile == null ? null : mobile,
    "password": password == null ? null : password,
    "location": location == null ? null : location,
    "avatar": avatar == null ? null : avatar,
    "banner_img": bannerImg == null ? null : bannerImg,
    "created_at": createdAt == null ? null : createdAt!.toIso8601String(),
    "updated_at": updatedAt == null ? null : updatedAt!.toIso8601String(),
    "created_ip": createdIp == null ? null : createdIp,
    "updated_ip": updatedIp == null ? null : updatedIp,
    "status": status == null ? null : status,
  };
}

class V {
  V({
    this.id,
    this.clientId,
    this.userId,
    this.customerName,
    this.location,
    this.mobile,
    this.comment,
    this.videoName,
    this.videoId,
    this.likes,
    this.rating,
    this.views,
    this.status,
    this.featureVideo,
    this.createdDate,
    this.length,
    this.unlikes,
    this.webhookDump,
    this.durationSec,
    this.durationStr,
    this.filesize,
    this.dimensions,
    this.videoSlug,
    this.source,
    this.postedFrom,
    this.s3Path,
    this.createdIp,
    this.updatedIp,
    this.clientName,
    this.logoImage,
    this.profileSlug,
    this.bucketName,
    this.baseUrl,
    this.videoUrl,
    this.thumbUrl,
    this.purl,
  });

  String? id;
  String? clientId;
  String? userId;
  String? customerName;
  String? location;
  String? mobile;
  String? comment;
  String? videoName;
  String? videoId;
  String? likes;
  String? rating;
  String? views;
  String? status;
  String? featureVideo;
  DateTime? createdDate;
  dynamic length;
  String? unlikes;
  String? webhookDump;
  String? durationSec;
  String? durationStr;
  String? filesize;
  String? dimensions;
  String? videoSlug;
  String? source;
  String? postedFrom;
  String? s3Path;
  String? createdIp;
  String? updatedIp;
  String? clientName;
  String? logoImage;
  String? profileSlug;
  String? bucketName;
  String? baseUrl;
  String? videoUrl;
  String? thumbUrl;
  String? purl;

  factory V.fromJson(Map<String, dynamic> json) => V(
    id: json["id"] == null ? null : json["id"],
    clientId: json["client_id"] == null ? null : json["client_id"],
    userId: json["userID"] == null ? null : json["userID"],
    customerName: json["customer_name"] == null ? null : json["customer_name"],
    location: json["location"] == null ? null : json["location"],
    mobile: json["mobile"] == null ? null : json["mobile"],
    comment: json["comment"] == null ? null : json["comment"],
    videoName: json["video_name"] == null ? null : json["video_name"],
    videoId: json["videoID"] == null ? null : json["videoID"],
    likes: json["likes"] == null ? null : json["likes"],
    rating: json["rating"] == null ? null : json["rating"],
    views: json["views"] == null ? null : json["views"],
    status: json["status"] == null ? null : json["status"],
    featureVideo: json["feature_video"] == null ? null : json["feature_video"],
    createdDate: json["created_date"] == null ? null : DateTime.parse(json["created_date"]),
    length: json["length"],
    unlikes: json["unlikes"] == null ? null : json["unlikes"],
    webhookDump: json["webhook_dump"] == null ? null : json["webhook_dump"],
    durationSec: json["duration_sec"] == null ? null : json["duration_sec"],
    durationStr: json["duration_str"] == null ? null : json["duration_str"],
    filesize: json["filesize"] == null ? null : json["filesize"],
    dimensions: json["dimensions"] == null ? null : json["dimensions"],
    videoSlug: json["video_slug"] == null ? null : json["video_slug"],
    source: json["source"] == null ? null : json["source"],
    postedFrom: json["posted_from"] == null ? null : json["posted_from"],
    s3Path: json["s3_path"] == null ? null : json["s3_path"],
    createdIp: json["created_ip"] == null ? null : json["created_ip"],
    updatedIp: json["updated_ip"] == null ? null : json["updated_ip"],
    clientName: json["clientName"] == null ? null : json["clientName"],
    logoImage: json["logo_image"] == null ? null : json["logo_image"],
    profileSlug: json["profile_slug"] == null ? null : json["profile_slug"],
    bucketName: json["bucketName"] == null ? null : json["bucketName"],
    baseUrl: json["baseURL"] == null ? null : json["baseURL"],
    videoUrl: json["video_url"] == null ? null : json["video_url"],
    thumbUrl: json["thumb_url"] == null ? null : json["thumb_url"],
    purl: json["purl"] == null ? null : json["purl"],
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "client_id": clientId == null ? null : clientId,
    "userID": userId == null ? null : userId,
    "customer_name": customerName == null ? null : customerName,
    "location": location == null ? null : location,
    "mobile": mobile == null ? null : mobile,
    "comment": comment == null ? null : comment,
    "video_name": videoName == null ? null : videoName,
    "videoID": videoId == null ? null : videoId,
    "likes": likes == null ? null : likes,
    "rating": rating == null ? null : rating,
    "views": views == null ? null : views,
    "status": status == null ? null : status,
    "feature_video": featureVideo == null ? null : featureVideo,
    "created_date": createdDate == null ? null : createdDate!.toIso8601String(),
    "length": length,
    "unlikes": unlikes == null ? null : unlikes,
    "webhook_dump": webhookDump == null ? null : webhookDump,
    "duration_sec": durationSec == null ? null : durationSec,
    "duration_str": durationStr == null ? null : durationStr,
    "filesize": filesize == null ? null : filesize,
    "dimensions": dimensions == null ? null : dimensions,
    "video_slug": videoSlug == null ? null : videoSlug,
    "source": source == null ? null : source,
    "posted_from": postedFrom == null ? null : postedFrom,
    "s3_path": s3Path == null ? null : s3Path,
    "created_ip": createdIp == null ? null : createdIp,
    "updated_ip": updatedIp == null ? null : updatedIp,
    "clientName": clientName == null ? null : clientName,
    "logo_image": logoImage == null ? null : logoImage,
    "profile_slug": profileSlug == null ? null : profileSlug,
    "bucketName": bucketName == null ? null : bucketName,
    "baseURL": baseUrl == null ? null : baseUrl,
    "video_url": videoUrl == null ? null : videoUrl,
    "thumb_url": thumbUrl == null ? null : thumbUrl,
    "purl": purl == null ? null : purl,
  };
}
