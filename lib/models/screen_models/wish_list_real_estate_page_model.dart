import 'package:web_demo/models/model.dart';

class WishListRealEstatePageModel {
  final List<ReviewModel> list;

  WishListRealEstatePageModel(
    this.list,
  );

  factory WishListRealEstatePageModel.fromJson(dynamic json) {
    final Iterable refactorList = json ?? [];

    final list = refactorList.map((item) {
      return ReviewModel.fromJson(item);
    }).toList();

    return WishListRealEstatePageModel(list);
  }
}
