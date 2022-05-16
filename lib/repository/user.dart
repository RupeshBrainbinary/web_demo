import 'dart:convert';

import 'package:web_demo/api/api.dart';
import 'package:web_demo/configs/config.dart';
import 'package:web_demo/models/model.dart';
import 'package:web_demo/utils/utils.dart';

class UserRepository {
  ///Fetch api login
  static Future<UserModel?> login({
    required String username,
    required String password,
  }) async {
    final Map<String, dynamic> params = {
      "username": username,
      "password": password,
      "xhr": "1",
    };
    final response = await Api.login(params);

    if (response.success) {
      return UserModel.fromJson(response.data);
    }
  }

  static Future<UserModel?> signUp({
    required String username,
    required String countryName,
    required String mobileNo,
    required String email,
    required String password,
    required String conPassword,
  }) async {
    final Map<String, dynamic> params = {
      "conperson": username,
      "location": countryName,
      "mobileno": mobileNo,
      "email": email,
      "comppassword": password,
      "confpassword": conPassword,
      "chanelName": null,
      "termsnpv": "terms",
    };
    final response = await Api.signUp(params);

    if (response.success) {
      return UserModel.fromJson(response.data);
    }
  }

  ///Fetch api validToken
  static Future<bool> validateToken() async {
    final response = await Api.validateToken();
    if (response.success) {
      return true;
    }
    return false;
  }

  ///Save User
  static Future<bool> saveUser({required UserModel user}) async {
    return await UtilPreferences.setString(
      Preferences.user,
      jsonEncode(user.toJson()),
    );
  }

  ///Load User
  static Future<UserModel?> loadUser() async {
    final result = UtilPreferences.getString(Preferences.user);
    if (result != null) {
      return UserModel.fromJson(jsonDecode(result));
    }
  }

  ///Delete User
  static Future<bool> deleteUser() async {
    return await UtilPreferences.remove(Preferences.user);
  }
}
