import 'package:web_demo/models/model.dart';

class ProductDetailRealEstatePageModel {
  final ReviewModel review;

  ProductDetailRealEstatePageModel({
    required this.review,
  });

  factory ProductDetailRealEstatePageModel.fromJson(Map<String, dynamic> json) {
    return ProductDetailRealEstatePageModel(
      review: ReviewModel.fromJson(json),
    );
  }
}
