import 'dart:convert';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  UserModel({
    required this.id,
    required this.name,
    required this.chanel,
    required this.isChannel,
    required this.slug,
    required this.email,
    required this.about,
    required this.emailActivationCode,
    required this.emailActivationStatus,
    required this.passwordCode,
    required this.passwordCodeStatus,
    required this.emailActivationAt,
    required this.mobile,
    required this.password,
    required this.location,
    required this.avatar,
    required this.bannerImg,
    required this.createdAt,
    required this.updatedAt,
    required this.createdIp,
    required this.updatedIp,
    required this.status,
  });

  final String id;
  final String name;
  final String chanel;
  final String isChannel;
  final String slug;
  final String email;
  final String about;
  final String emailActivationCode;
  final String emailActivationStatus;
  final String passwordCode;
  final String passwordCodeStatus;
  final String emailActivationAt;
  final String mobile;
  final String password;
  final String location;
  final String avatar;
  final String bannerImg;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String createdIp;
  final String updatedIp;
  final String status;

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
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
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
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
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "created_ip": createdIp,
    "updated_ip": updatedIp,
    "status": status,
  };
}
