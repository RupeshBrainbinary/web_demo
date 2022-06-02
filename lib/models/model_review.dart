import 'package:web_demo/models/model.dart';

class ReviewModel {
  final int id;
  int views;
  int likes;
  final String clientName;
  final String clientImage;
  final String clientLocation;
  final String comment;
  final String image;
  final String video;
  final double rate;
  final String channelName;
  final String place;
  final String reviewDate;
  final String profileSlug;
  final String videoSlug;
  final LocationModel? location;
  final bool favorite;

  ReviewModel(
      {required this.id,
      required this.views,
      required this.likes,
      required this.clientName,
      required this.clientImage,
      required this.clientLocation,
      required this.comment,
      required this.image,
      required this.video,
      required this.rate,
      required this.channelName,
      required this.place,
      required this.profileSlug,
      required this.videoSlug,
      required this.location,
      required this.reviewDate,
      required this.favorite});

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      id: json['id'] ?? 0,
      views: json['v'] ?? 0,
      likes: json['l'] ?? 0,
      rate: toDouble(json['rt']),
      clientName: json['cn'] ?? '',
      clientImage: json['climg'] ?? '',
      clientLocation: json['cl'] ?? '',
      comment: json['cmt'] ?? '',
      image: json['img'] ?? '',
      video: json['video'] ?? '',
      channelName: json['un'] ?? '',
      place: json['loc'] ?? '',
      profileSlug: json['psl'] ?? '',
      videoSlug: json['vsl'] ?? '',
      location:
          LocationModel(title: "Dindigul", lat: 10.365581, long: 77.970657),
      reviewDate: json['cd'] ?? '',
      favorite: false,
    );
  }

  String shareLink() {
    return "https://app.reviewclip.com/review/$videoSlug";
  }
}

double toDouble(dynamic value) {
  if (null != value) {
    if (value is int) {
      return value.toDouble();
    } else if (value is double) {
      return value;
    } else if (value is String && value.isNotEmpty) {
      return double.parse(value);
    }
  }
  return 0.0;
}
