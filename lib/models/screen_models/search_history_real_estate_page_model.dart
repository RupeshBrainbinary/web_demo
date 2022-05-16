import 'package:web_demo/models/model.dart';

class SearchHistoryRealEstatePageModel {
  final List<CategoryModel> discover;
  final List<ReviewModel> recently;
  final List<ReviewModel> history;

  SearchHistoryRealEstatePageModel({
    required this.discover,
    required this.recently,
    required this.history,
  });

  factory SearchHistoryRealEstatePageModel.fromJson(Map<String, dynamic> json) {
    final Iterable refactorDiscover = json['discover'] ?? [];
    final Iterable refactorRecently = json['recently'] ?? [];
    final Iterable refactorHistory = json['history'] ?? [];

    final listDiscover = refactorDiscover.map((item) {
      return CategoryModel.fromJson(item);
    }).toList();

    final listRecently = refactorRecently.map((item) {
      return ReviewModel.fromJson(item);
    }).toList();

    final listHistory = refactorHistory.map((item) {
      return ReviewModel.fromJson(item);
    }).toList();

    return SearchHistoryRealEstatePageModel(
      discover: listDiscover,
      recently: listRecently,
      history: listHistory,
    );
  }
}
