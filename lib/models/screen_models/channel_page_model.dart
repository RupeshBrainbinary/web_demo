import 'package:web_demo/models/model_channel.dart';

class ChannelPageModel {
  final List<ChannelModel> channels;

  ChannelPageModel({
    required this.channels,
  });

  factory ChannelPageModel.fromJson(dynamic json) {
    final Iterable refactorList = json ?? [];

    final list = refactorList.map((item) {
      return ChannelModel.fromJson(item);
    }).toList();

    return ChannelPageModel(channels: list);
  }
}
