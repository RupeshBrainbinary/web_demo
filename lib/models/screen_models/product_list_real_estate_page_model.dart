import 'package:web_demo/models/model.dart';

class ProductListRealEstatePageModel {
  final List<ReviewModel> list;

  ProductListRealEstatePageModel(
    this.list,
  );

  factory ProductListRealEstatePageModel.fromJson(dynamic json) {
    return ProductListRealEstatePageModel(
      List.from(json ?? []).map((item) {
        return ReviewModel.fromJson(item);
      }).toList(),
    );
  }
}
