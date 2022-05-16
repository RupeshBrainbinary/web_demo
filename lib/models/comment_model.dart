// To parse this JSON data, do
//
//     final userModel = userModelFromJson(jsonString);

import 'dart:convert';

CommentRes commentResFromJson(String str) => CommentRes.fromJson(json.decode(str));

String commentResToJson(CommentRes data) => json.encode(data.toJson());

class CommentRes {
  CommentRes({
    this.chanel,
    this.reports,
    this.comments,
    this.commentsCount,
    this.likesCount,
  });

  Chanel? chanel;
  List<Comment>? reports;
  List<Comment>? comments;
  int? commentsCount;
  String? likesCount;

  factory CommentRes.fromJson(Map<String, dynamic> json) => CommentRes(
    chanel: json["chanel"] == null ? null : Chanel.fromJson(json["chanel"]),
    reports: json["reports"] == null ? null : List<Comment>.from(json["reports"].map((x) => Comment.fromJson(x))),
    comments: json["comments"] == null ? null : List<Comment>.from(json["comments"].map((x) => Comment.fromJson(x))),
    commentsCount: json["comments_count"],
    likesCount: json["likes_count"],
  );

  Map<String, dynamic> toJson() => {
    "chanel": chanel == null ? null : chanel!.toJson(),
    "reports": reports == null ? null : List<dynamic>.from(reports!.map((x) => x.toJson())),
    "comments": comments == null ? null : List<dynamic>.from(comments!.map((x) => x.toJson())),
    "comments_count": commentsCount,
    "likes_count": likesCount,
  };
}

class Chanel {
  Chanel({
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

  factory Chanel.fromJson(Map<String, dynamic> json) => Chanel(
    id: json["id"],
    name: json["name"],
    chanel: json["chanel"],
    isChannel: json["is_channel"],
    slug: json["slug"],
    email: json["email"],
    about: json["about"],
    emailActivationCode: json["email_activation_code"],
    emailActivationStatus: json["email_activation_status"],
    passwordCode: json["password_code"],
    passwordCodeStatus: json["password_code_status"],
    emailActivationAt: json["email_activation_at"],
    mobile: json["mobile"],
    password: json["password"],
    location: json["location"],
    avatar: json["avatar"],
    bannerImg: json["banner_img"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    createdIp: json["created_ip"],
    updatedIp: json["updated_ip"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "chanel": chanel,
    "is_channel": isChannel,
    "slug": slug,
    "email": email,
    "about": about,
    "email_activation_code": emailActivationCode,
    "email_activation_status": emailActivationStatus,
    "password_code": passwordCode,
    "password_code_status": passwordCodeStatus,
    "email_activation_at": emailActivationAt,
    "mobile": mobile,
    "password": password,
    "location": location,
    "avatar": avatar,
    "banner_img": bannerImg,
    "created_at": createdAt == null ? null : createdAt!.toIso8601String(),
    "updated_at": updatedAt == null ? null : updatedAt!.toIso8601String(),
    "created_ip": createdIp,
    "updated_ip": updatedIp,
    "status": status,
  };
}

class Comment {
  Comment({
    this.id,
    this.clientId,
    this.content,
    this.videoId,
    this.createdDate,
    this.createdIp,
    this.status,
  });

  String? id;
  String? clientId;
  String? content;
  String? videoId;
  DateTime? createdDate;
  String? createdIp;
  String? status;

  factory Comment.fromJson(Map<String, dynamic> json) => Comment(
    id: json["id"],
    clientId: json["client_id"],
    content: json["content"],
    videoId: json["video_id"],
    createdDate: json["created_date"] == null ? null : DateTime.parse(json["created_date"]),
    createdIp: json["created_ip"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "client_id": clientId,
    "content": content,
    "video_id": videoId,
    "created_date": createdDate == null ? null : createdDate!.toIso8601String(),
    "created_ip": createdIp,
    "status": status,
  };
}
