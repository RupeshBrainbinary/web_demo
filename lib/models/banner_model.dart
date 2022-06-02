// To parse this JSON data, do
//
//     final bannerModel = bannerModelFromJson(jsonString);

import 'dart:convert';

BannerModel bannerModelFromJson(String str) =>
    BannerModel.fromJson(json.decode(str));

String bannerModelToJson(BannerModel data) => json.encode(data.toJson());

class BannerModel {
  BannerModel({
    this.bannerData,
    this.status,
  });

  List<BannerData>? bannerData;
  int? status;

  factory BannerModel.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic> map = json;
    map.removeWhere((key, value) => key == 'status');
    List<BannerData> list = [];
    map.forEach((key, value) {
      list.add(BannerData.fromJson(value));
    });
    return BannerModel(
      bannerData: list,
      status: json["status"] == null ? null : json["status"],
    );
  }

  Map<String, dynamic> toJson() => {
        "": bannerData == null
            ? null
            : List<dynamic>.from(bannerData!.map((x) => x.toJson())),
        "status": status == null ? null : status,
      };
}

class BannerData {
  BannerData({
    this.banner,
  });

  Banner? banner;

  factory BannerData.fromJson(Map<String, dynamic> json) => BannerData(
        banner: json["data"] == null ? null : Banner.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "data": banner == null ? null : banner!.toJson(),
      };
}

class Banner {
  Banner({
    this.clentName,
    this.clentUrl,
    this.clentId,
    this.clentDepplink,
    this.clentDeppslug,
    this.clentBanner,
  });

  String? clentName;
  String? clentUrl;
  String? clentId;
  String? clentDepplink;
  String? clentDeppslug;
  String? clentBanner;

  factory Banner.fromJson(Map<String, dynamic> json) => Banner(
    clentName: json["clent_name"] == null ? null : json["clent_name"],
    clentUrl: json["clent_url"] == null ? null : json["clent_url"],
    clentId: json["clent_id"] == null ? null : json["clent_id"],
    clentDepplink: json["clent_depplink"] == null ? null : json["clent_depplink"],
    clentDeppslug: json["clent_deppslug"] == null ? null : json["clent_deppslug"],
    clentBanner: json["clent_banner"] == null ? null : json["clent_banner"],
  );

  Map<String, dynamic> toJson() => {
    "clent_name": clentName == null ? null : clentName,
    "clent_url": clentUrl == null ? null : clentUrl,
    "clent_id": clentId == null ? null : clentId,
    "clent_depplink": clentDepplink == null ? null : clentDepplink,
    "clent_deppslug": clentDeppslug == null ? null : clentDeppslug,
    "clent_banner": clentBanner == null ? null : clentBanner,
  };
}
