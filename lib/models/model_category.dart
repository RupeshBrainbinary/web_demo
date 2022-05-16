import 'package:flutter/cupertino.dart';
import 'package:web_demo/utils/utils.dart';

class CategoryModel {
  final int id;
  final String title;
  final int count;
  final String image;
  final String icon;
  final Color color;
  final String slug;

  CategoryModel({
    required this.id,
    required this.title,
    required this.count,
    required this.image,
    required this.icon,
    required this.color,
    required this.slug
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    //final icon = UtilIcon.getIconData(json['icon'] ?? "Unknown");
    final color = UtilColor.getColorFromHex(json['color'] ?? "#ff8a65");
    return CategoryModel(
      id: json['cid'] ?? 0,
      title: json['n'] ?? '',
      //title
      count: json['count'] ?? 0,
      //count
      image: json['image'] ?? '',
      icon: json['ci'] ?? '',
      //icon
      color: color,
      slug: json['slug']
    );
  }
}
