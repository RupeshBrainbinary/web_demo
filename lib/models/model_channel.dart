class ChannelModel {
  final int id;
  final String name;
  final String channelName;
  final String about;
  final String location;
  final String avatar;
  final int videoCount;
  final int videoViews;
  final int videoLikes;
  final int subscribers;

  ChannelModel(
      {required this.id,
      required this.name,
      required this.channelName,
      required this.about,
      required this.location,
      required this.avatar,
      required this.videoCount,
      required this.videoViews,
      required this.videoLikes,
      required this.subscribers});

  factory ChannelModel.fromJson(Map<String, dynamic> json) {
    return ChannelModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      channelName: json['ch'] ?? '',
      about: json['about'] ?? '',
      location: json['location'] ?? '',
      avatar: json['avatar'] ?? '',
      videoCount: toInt(json['video_count']),
      videoViews: toInt(json['video_views']),
      videoLikes: toInt(json['video_likes']),
      subscribers: toInt(json['subscribers']),
    );
  }
}

int toInt(dynamic value) {
  if (null != value) {
    if (value is int) {
      return value;
    } else if (value is double) {
      return value.toInt();
    } else if (value is String && value.isNotEmpty) {
      return int.parse(value);
    }
  }
  return 0;
}
