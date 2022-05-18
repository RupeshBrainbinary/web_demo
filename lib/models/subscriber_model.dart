// To parse this JSON data, do
//
//     final subscriberModel = subscriberModelFromJson(jsonString);

import 'dart:convert';

SubscriberModel subscriberModelFromJson(String str) => SubscriberModel.fromJson(json.decode(str));

String subscriberModelToJson(SubscriberModel data) => json.encode(data.toJson());

class SubscriberModel {
  SubscriberModel({
    this.status,
    this.data,
  });

  int? status;
  Data? data;

  factory SubscriberModel.fromJson(Map<String, dynamic> json) => SubscriberModel(
    status: json["status"] == null ? null : json["status"],
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status == null ? null : status,
    "data": data == null ? null : data!.toJson(),
  };
}

class Data {
  Data({
    this.subscribed,
  });

  List<Subscribed>? subscribed;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    subscribed: json["subscribed"] == null ? null : List<Subscribed>.from(json["subscribed"].map((x) => Subscribed.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "subscribed": subscribed == null ? null : List<dynamic>.from(subscribed!.map((x) => x.toJson())),
  };
}

class Subscribed {
  Subscribed({
    this.subscribedDate,
    this.name,
    this.location,
    this.chanel,
    this.slug,
  });

  DateTime? subscribedDate;
  String? name;
  String? location;
  String? chanel;
  String? slug;

  factory Subscribed.fromJson(Map<String, dynamic> json) => Subscribed(
    subscribedDate: json["subscribed_date"] == null ? null : DateTime.parse(json["subscribed_date"]),
    name: json["name"] == null ? null : json["name"],
    location: json["location"] == null ? null : json["location"],
    chanel: json["chanel"] == null ? null : json["chanel"],
    slug: json["slug"] == null ? null : json["slug"],
  );

  Map<String, dynamic> toJson() => {
    "subscribed_date": subscribedDate == null ? null : subscribedDate!.toIso8601String(),
    "name": name == null ? null : name,
    "location": location == null ? null : location,
    "chanel": chanel == null ? null : chanel,
    "slug": slug == null ? null : slug,
  };
}
