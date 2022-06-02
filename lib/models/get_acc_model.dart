// To parse this JSON data, do
//
//     final getAccModel = getAccModelFromJson(jsonString);

import 'dart:convert';

GetAccModel getAccModelFromJson(String str) => GetAccModel.fromJson(json.decode(str));

String getAccModelToJson(GetAccModel data) => json.encode(data.toJson());

class GetAccModel {
  GetAccModel({
    this.status,
    this.msg,
    this.data,
  });

  int? status;
  String? msg;
  Data? data;

  factory GetAccModel.fromJson(Map<String, dynamic> json) => GetAccModel(
    status: json["status"] == null ? null : json["status"],
    msg: json["msg"] == null ? null : json["msg"],
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status == null ? null : status,
    "msg": msg == null ? null : msg,
    "data": data == null ? null : data!.toJson(),
  };
}

class Data {
  Data({
    this.id,
    this.name,
    this.username,
    this.password,
    this.passwordCode,
    this.passwordCodeStatus,
    this.category,
    this.status,
    this.email,
    this.createdDate,
    this.firstname,
    this.lastname,
    this.phone,
    this.mobile,
    this.websiteUrl,
    this.facebook,
    this.twitter,
    this.googlePlus,
    this.youtube,
    this.vimeo,
    this.pinterest,
    this.instagram,
    this.linkedin,
    this.logoImage,
    this.about,
    this.bannerImage,
    this.companyName,
    this.country,
    this.state,
    this.city,
    this.location,
    this.zip,
    this.address,
    this.contactPerson,
    this.paymentMethod,
    this.totalVideos,
    this.totalRating,
    this.plan,
    this.planDuration,
    this.paidAmount,
    this.paymentMode,
    this.chequeRefNo,
    this.paymentBank,
    this.paymentDate,
    this.amountPaid,
    this.map,
    this.tagline,
    this.profileSlug,
    this.promoVideo,
  });

  String? id;
  String? name;
  String? username;
  String? password;
  String? passwordCode;
  String? passwordCodeStatus;
  String? category;
  String? status;
  String? email;
  DateTime? createdDate;
  String? firstname;
  String? lastname;
  String? phone;
  String? mobile;
  String? websiteUrl;
  String? facebook;
  String? twitter;
  String? googlePlus;
  String? youtube;
  String? vimeo;
  String? pinterest;
  String? instagram;
  String? linkedin;
  String? logoImage;
  String? about;
  String? bannerImage;
  String? companyName;
  String? country;
  String? state;
  String? city;
  String? location;
  String? zip;
  String? address;
  String? contactPerson;
  String? paymentMethod;
  String? totalVideos;
  String? totalRating;
  String? plan;
  String? planDuration;
  String? paidAmount;
  String? paymentMode;
  String? chequeRefNo;
  String? paymentBank;
  DateTime? paymentDate;
  String? amountPaid;
  String? map;
  String? tagline;
  String? profileSlug;
  String? promoVideo;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["id"] == null ? null : json["id"],
    name: json["name"] == null ? null : json["name"],
    username: json["username"] == null ? null : json["username"],
    password: json["password"] == null ? null : json["password"],
    passwordCode: json["password_code"] == null ? null : json["password_code"],
    passwordCodeStatus: json["password_code_status"] == null ? null : json["password_code_status"],
    category: json["category"] == null ? null : json["category"],
    status: json["status"] == null ? null : json["status"],
    email: json["email"] == null ? null : json["email"],
    createdDate: json["created_date"] == null ? null : DateTime.parse(json["created_date"]),
    firstname: json["firstname"] == null ? null : json["firstname"],
    lastname: json["lastname"] == null ? null : json["lastname"],
    phone: json["phone"] == null ? null : json["phone"],
    mobile: json["mobile"] == null ? null : json["mobile"],
    websiteUrl: json["website_url"] == null ? null : json["website_url"],
    facebook: json["facebook"] == null ? null : json["facebook"],
    twitter: json["twitter"] == null ? null : json["twitter"],
    googlePlus: json["google_plus"] == null ? null : json["google_plus"],
    youtube: json["youtube"] == null ? null : json["youtube"],
    vimeo: json["vimeo"] == null ? null : json["vimeo"],
    pinterest: json["pinterest"] == null ? null : json["pinterest"],
    instagram: json["instagram"] == null ? null : json["instagram"],
    linkedin: json["linkedin"] == null ? null : json["linkedin"],
    logoImage: json["logo_image"] == null ? null : json["logo_image"],
    about: json["about"] == null ? null : json["about"],
    bannerImage: json["banner_image"] == null ? null : json["banner_image"],
    companyName: json["company_name"] == null ? null : json["company_name"],
    country: json["country"] == null ? null : json["country"],
    state: json["state"] == null ? null : json["state"],
    city: json["city"] == null ? null : json["city"],
    location: json["location"] == null ? null : json["location"],
    zip: json["zip"] == null ? null : json["zip"],
    address: json["address"] == null ? null : json["address"],
    contactPerson: json["contact_person"] == null ? null : json["contact_person"],
    paymentMethod: json["paymentMethod"] == null ? null : json["paymentMethod"],
    totalVideos: json["total_videos"] == null ? null : json["total_videos"],
    totalRating: json["total_rating"] == null ? null : json["total_rating"],
    plan: json["plan"] == null ? null : json["plan"],
    planDuration: json["plan_duration"] == null ? null : json["plan_duration"],
    paidAmount: json["paid_amount"] == null ? null : json["paid_amount"],
    paymentMode: json["payment_mode"] == null ? null : json["payment_mode"],
    chequeRefNo: json["cheque_ref_no"] == null ? null : json["cheque_ref_no"],
    paymentBank: json["payment_bank"] == null ? null : json["payment_bank"],
    paymentDate: json["payment_date"] == null ? null : DateTime.parse(json["payment_date"]),
    amountPaid: json["amount_paid"] == null ? null : json["amount_paid"],
    map: json["map"] == null ? null : json["map"],
    tagline: json["tagline"] == null ? null : json["tagline"],
    profileSlug: json["profile_slug"] == null ? null : json["profile_slug"],
    promoVideo: json["promo_video"] == null ? null : json["promo_video"],
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "name": name == null ? null : name,
    "username": username == null ? null : username,
    "password": password == null ? null : password,
    "password_code": passwordCode == null ? null : passwordCode,
    "password_code_status": passwordCodeStatus == null ? null : passwordCodeStatus,
    "category": category == null ? null : category,
    "status": status == null ? null : status,
    "email": email == null ? null : email,
    "created_date": createdDate == null ? null : createdDate!.toIso8601String(),
    "firstname": firstname == null ? null : firstname,
    "lastname": lastname == null ? null : lastname,
    "phone": phone == null ? null : phone,
    "mobile": mobile == null ? null : mobile,
    "website_url": websiteUrl == null ? null : websiteUrl,
    "facebook": facebook == null ? null : facebook,
    "twitter": twitter == null ? null : twitter,
    "google_plus": googlePlus == null ? null : googlePlus,
    "youtube": youtube == null ? null : youtube,
    "vimeo": vimeo == null ? null : vimeo,
    "pinterest": pinterest == null ? null : pinterest,
    "instagram": instagram == null ? null : instagram,
    "linkedin": linkedin == null ? null : linkedin,
    "logo_image": logoImage == null ? null : logoImage,
    "about": about == null ? null : about,
    "banner_image": bannerImage == null ? null : bannerImage,
    "company_name": companyName == null ? null : companyName,
    "country": country == null ? null : country,
    "state": state == null ? null : state,
    "city": city == null ? null : city,
    "location": location == null ? null : location,
    "zip": zip == null ? null : zip,
    "address": address == null ? null : address,
    "contact_person": contactPerson == null ? null : contactPerson,
    "paymentMethod": paymentMethod == null ? null : paymentMethod,
    "total_videos": totalVideos == null ? null : totalVideos,
    "total_rating": totalRating == null ? null : totalRating,
    "plan": plan == null ? null : plan,
    "plan_duration": planDuration == null ? null : planDuration,
    "paid_amount": paidAmount == null ? null : paidAmount,
    "payment_mode": paymentMode == null ? null : paymentMode,
    "cheque_ref_no": chequeRefNo == null ? null : chequeRefNo,
    "payment_bank": paymentBank == null ? null : paymentBank,
    "payment_date": paymentDate == null ? null : "${paymentDate!.year.toString().padLeft(4, '0')}-${paymentDate!.month.toString().padLeft(2, '0')}-${paymentDate!.day.toString().padLeft(2, '0')}",
    "amount_paid": amountPaid == null ? null : amountPaid,
    "map": map == null ? null : map,
    "tagline": tagline == null ? null : tagline,
    "profile_slug": profileSlug == null ? null : profileSlug,
    "promo_video": promoVideo == null ? null : promoVideo,
  };
}
