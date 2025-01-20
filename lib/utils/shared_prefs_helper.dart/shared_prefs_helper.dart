import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  static const String tokenKey = 'INQYRYLOGINTOKEN';
  static const String roleKey = 'ROLE';
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

  // for saving which role is current
  static Future<void> saveRole(String role) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(roleKey, role);
  }

  // to get token
  static Future<String> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(tokenKey) ?? '';
  }

  // to get which role is current
  static Future<String> getRole() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(roleKey) ?? '';
  }

  // clear token
  static Future<bool> clearToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.remove(tokenKey);
  }

  // clear token
  static Future<bool> clearRole() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.remove(roleKey);
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
