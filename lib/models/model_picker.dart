import 'package:flutter/cupertino.dart';

class PickerModel<T> {
  final String? title;
  final List<T> selected;
  final List<T> data;
  final TextEditingController controller;
  final bool? isShow;

  PickerModel({
    this.title,
    required this.selected,
    required this.data,
    required this.controller,
    this.isShow

  });
}
