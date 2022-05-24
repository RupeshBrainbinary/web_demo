import 'package:shared_preferences/shared_preferences.dart';

class Preferences {
  static SharedPreferences? instance;

  static const String reviewIntro = 'review';
  static const String user = 'user';
  static const String clientId = 'clientId';
  static const String language = 'language';
  static const String notification = 'notification';
  static const String theme = 'theme';
  static const String darkOption = 'darkOption';
  static const String font = 'font';
  static const String search = 'search';
  static const String keyboardHeight = 'keyboardHeight';
  static const String countryId = 'countryId';
  static const String channelName = 'channelName';

  static Future<void> setPreferences() async {
    instance = await SharedPreferences.getInstance();
  }

  ///Singleton factory
  static final Preferences _instance = Preferences._internal();

  factory Preferences() {
    return _instance;
  }

  Preferences._internal();
}
