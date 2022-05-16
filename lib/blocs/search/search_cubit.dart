import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:web_demo/api/api.dart';
import 'package:web_demo/models/model.dart';

class SearchCubit extends Cubit<dynamic> {
  SearchCubit() : super(null);

  Timer? _timer;

  void onSearch(String keyword) async {
    emit(null);
    _timer?.cancel();
    _timer = Timer(const Duration(milliseconds: 500), () {
      _fetchData(keyword);
    });
  }

  void _fetchData(String keyword) async {
    if (keyword.isNotEmpty) {
      final result = await Api.onSearchData();
      if (result.success) {
        List<ReviewModel> list = result.data.map<ReviewModel>((item) {
          return ReviewModel.fromJson(item);
        }).toList();
        emit(list.where((item) {
          return (item.clientName
                  .toUpperCase()
                  .contains(keyword.toUpperCase()) ||
              item.clientName.toUpperCase().contains(keyword.toUpperCase()) ||
              item.channelName.toUpperCase().contains(keyword.toUpperCase()));
        }).toList());
      }
    }
  }
}
