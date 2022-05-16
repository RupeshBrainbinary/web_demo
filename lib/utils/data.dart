import 'package:web_demo/utils/utils.dart';

class UtilData {
  static Future<Map<String, dynamic>> login() async {
    return await UtilAsset.loadJson("assets/data/login.json");
  }

  static Future<Map<String, dynamic>> validateToken() async {
    return await UtilAsset.loadJson("assets/data/login.json");
  }

  static Future<Map<String, dynamic>> getCategory() async {
    return await UtilAsset.loadJson("assets/data/category.json");
  }

  static Future<Map<String, dynamic>> getAboutUs() async {
    return await UtilAsset.loadJson("assets/data/about_us.json");
  }

  static Future<Map<String, dynamic>> getMessage() async {
    return await UtilAsset.loadJson("assets/data/message.json");
  }

  static Future<Map<String, dynamic>> getDetailMessage(int id) async {
    return await UtilAsset.loadJson(
      "assets/data/message_detail_$id.json",
    );
  }

  static Future<Map<String, dynamic>> getNotification() async {
    return await UtilAsset.loadJson("assets/data/notification.json");
  }

  static Future<Map<String, dynamic>> getLocationList() async {
    return await UtilAsset.loadJson("assets/data/location.json");
  }

  static Future<Map<String, dynamic>> getReview() async {
    return await UtilAsset.loadJson("assets/data/review.json");
  }


  ///Home Real Estate
  static Future<Map<String, dynamic>> getHomeRealEstate() async {
    var result = await UtilAsset.loadJson("assets/data/home_real_estate.json");
    return result;
  }

  ///Singleton factory
  static final UtilData _instance = UtilData._internal();

  factory UtilData() {
    return _instance;
  }

  UtilData._internal();
}
