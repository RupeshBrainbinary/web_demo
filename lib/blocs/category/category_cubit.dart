import 'package:bloc/bloc.dart';
import 'package:web_demo/models/model.dart';
import 'package:web_demo/models/screen_models/category_page_model.dart';
import 'package:web_demo/repository/category_repository.dart';

class CategoryCubit extends Cubit<List<CategoryModel>> {
  CategoryCubit() : super(<CategoryModel>[]);

  //load categories
  Future<CategoryPageModel?> loadCategories() async {
    CategoryPageModel? categoryPageModel =
        await CategoryRepository.loadCategories();
    if (null != categoryPageModel) {
      emit(categoryPageModel.categories);
    }
    return categoryPageModel;
  }
}
