import 'package:web_demo/models/model.dart';

class ProductListPageModel {
  final List<ProductModel> list;

  ProductListPageModel(
    this.list,
  );

  factory ProductListPageModel.fromJson(dynamic json) {
    return ProductListPageModel(
      List.from(json ?? []).map((item) {
        return ProductModel.fromJson(item);
      }).toList(),
    );
  }
}
