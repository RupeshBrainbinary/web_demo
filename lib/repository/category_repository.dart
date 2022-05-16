import 'package:web_demo/api/api.dart';
import 'package:web_demo/configs/preferences.dart';
import 'package:web_demo/models/screen_models/category_page_model.dart';
import 'package:web_demo/utils/preferences.dart';

class CategoryRepository {
  ///Fetch categories
  static Future<CategoryPageModel?> loadCategories() async {
    final response = await Api.getCategory(
        UtilPreferences.get(Preferences.countryId) == null
            ? "1"
            : UtilPreferences.get(Preferences.countryId).toString());
    /*if (response.success) {
      return CategoryPageModel.fromJson(response.data);
    }*/
    return CategoryPageModel(response);
  }
}
