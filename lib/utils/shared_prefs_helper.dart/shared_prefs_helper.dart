import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  static const String tokenKey = 'INQYRYLOGINTOKEN';
  static const String registerTokenKey = 'INQYRYREGISTERTOKEN';
  static const String refKey = 'REFKEY';
  static const String userIdKey = 'USER_ID';
  static const String businessUserIdKey = 'BUSINESS_USER_ID';
  static const String businessIdKey = 'BUSINESS_ID';
  static const String permissionListKey = 'PERMISSION_LIST';

  // for save token
  static Future<void> saveToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(tokenKey, token);
  }

  // to get token
  static Future<String> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(tokenKey) ?? '';
  }

  // clear token
  static Future<bool> clearToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.remove(tokenKey);
  }

  // for clear shared preferences
  static Future<bool> clearShared() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.clear();
  }

  // business name
  static Future<void> saveString(String key, String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(key, value);
  }

  // to get token
  static Future<String> getSharedString(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.getString(key) ?? '';
  }

  static Future<void> removeSharedString(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(key);
  }
}
