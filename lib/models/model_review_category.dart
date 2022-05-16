import 'package:flutter/cupertino.dart';
import 'package:web_demo/utils/utils.dart';

class CategoryReviewModel {
  final int id;
  final String title;
  final int count;
  final String image;
  final IconData icon;
  final Color color;

  CategoryReviewModel({
    required this.id,
    required this.title,
    required this.count,
    required this.image,
    required this.icon,
    required this.color,
  });

  factory CategoryReviewModel.fromJson(Map<String, dynamic> json) {
    final icon = UtilIcon.getIconData(json['icon'] ?? "Unknown");
    final color = UtilColor.getColorFromHex(json['color'] ?? "#ff8a65");
    return CategoryReviewModel(
      id: json['cid'] ?? 0,
      title: json['n'] ?? 'Unknown',
      count: json['count'] ?? 0,
      image: json['ci'] ?? 'Unknown',
      icon: icon,
      color: color,
    );
  }
}
