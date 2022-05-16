import 'package:web_demo/models/model.dart';

import '../model_channel.dart';

class HomeRealEstatePageModel {
  final List<CountryModel> country;
  final List<ChannelModel> channels;
  final List<ReviewModel> popular;

  //final List<ReviewModel> recommend;

  HomeRealEstatePageModel({
    required this.country,
    required this.channels,
    required this.popular,
    //required this.recommend,
  });

  factory HomeRealEstatePageModel.fromJson(Map<String, dynamic> json) {
    return HomeRealEstatePageModel(
      country: (json['country'] as List).map((e) {
        return CountryModel.fromJson(e);
      }).toList(),
      channels: (json['channels'] as List).map((e) {
        return ChannelModel.fromJson(e);
      }).toList(),
      popular: (json['popular'] as List).map((e) {
        return ReviewModel.fromJson(e);
      }).toList(),
      /*recommend: (json['recommend'] as List).map((e) {
        return ReviewModel.fromJson(e);
      }).toList(),*/
    );
  }
}
