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
  static const String nameKey = "NAME";
  static const String mobileNumberKey = "MOBILE";
  static const String branchIdKey = "BRANCHID";
  static const String dobKey = "DOB";
  static const String idKey = "ID";
  static const String addressKey = "ADDRESS";
  static const String emailKey = "EMAIL";
  static const String formTokenKey = "FORMTOKEN";
  static const String fcmToken = "FCMTOKEN";
  static const String languageKey = "LANGUAGE";

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

  // save name
  static Future<void> saveName(String name) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(nameKey, name);
  }

  // save mobile number
  static Future<void> saveMobileNumber(String mobileNumber) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(mobileNumberKey, mobileNumber);
  }

  // save branchId
  static Future<void> saveBranchId(String branchId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(branchIdKey, branchId);
  }

  // save id
  static Future<void> saveId(String id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(idKey, id);
  }

  // save address
  static Future<void> saveAddress(String address) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(addressKey, address);
  }

  // save email
  static Future<void> saveEmail(String email) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(emailKey, email);
  }

  static Future<void> saveFormToken(String formToken) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(formTokenKey, formToken);
  }

  // save dob
  static Future<void> saveDOB(String dob) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(dobKey, dob);
  }

  // save fcm token
  static Future<void> saveFCMToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(fcmToken, token);
  }

  // save fcm token
  static Future<void> saveLanguage(String lang) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(languageKey, lang);
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

  // get name
  static Future<String> getName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(nameKey) ?? '';
  }

  // get mobile number
  static Future<String> getMobileNumber() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(mobileNumberKey) ?? '';
  }

  // get branch id
  static Future<String> getBranchId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(branchIdKey) ?? '';
  }

  // get id
  static Future<String> getId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(idKey) ?? '';
  }

  // get address
  static Future<String> getAddress() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(addressKey) ?? '';
  }

  // get email
  static Future<String> getEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(emailKey) ?? '';
  }

  // get formToken
  static Future<String> getFormToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(formTokenKey) ?? '';
  }

  // get dob
  static Future<String> getDOB() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(dobKey) ?? '';
  }

  // get fcm token
  static Future<String> getFCMToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(fcmToken) ?? "";
  }

  // get fcm token
  static Future<String> getLanguage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(languageKey) ?? "";
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

  // get name
  static Future<bool> clearName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.remove(nameKey);
  }

  // clear mobile number
  static Future<bool> clearMobileNumber() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.remove(mobileNumberKey);
  }

  // clear branch id
  static Future<bool> clearBranchId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.remove(branchIdKey);
  }

  // clear id
  static Future<bool> clearId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.remove(idKey);
  }

  // clear address
  static Future<bool> clearAddress() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.remove(addressKey);
  }

  // clear email
  static Future<bool> clearEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.remove(emailKey);
  }

  // clear formToken
  static Future<bool> clearFormToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.remove(formTokenKey);
  }

  // clear dob
  static Future<bool> clearDOB() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.remove(dobKey);
  }

  // clear fcm token
  static Future<bool> clearFCMToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.remove(fcmToken);
  }

  // clear fcm token
  static Future<bool> clearLanguage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.remove(languageKey);
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
