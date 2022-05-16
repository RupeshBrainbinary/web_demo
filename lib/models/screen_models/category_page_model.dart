import 'package:web_demo/models/model.dart';

class CategoryPageModel {
  final List<CategoryModel> categories;

  CategoryPageModel(
    this.categories,
  );

  factory CategoryPageModel.fromJson(List<dynamic> json) {
    final listCategory = json.map((item) {
      return CategoryModel.fromJson(item as Map<String,dynamic>);
    }).toList();

    return CategoryPageModel(listCategory);
  }
}
