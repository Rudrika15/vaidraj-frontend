import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:vaidraj/models/update_lang_model.dart';
import 'package:vaidraj/services/update_lang_service/update_lang_service.dart';

class LocalizationProvider extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  UpdateLangService updateLangService = UpdateLangService();
  UpdateLangModel? updateLangModel;
  static const String _boxName = 'settings';
  static const String _key = "language";

  Map<String, String> _localizedStrings = {};
  String _currentLocal = '';

  LocalizationProvider() {
    _loadLanguage();
  }

  String get currentLocale => _currentLocal;

  void setCurrentLocal({required String langToSet}) {
    _currentLocal = langToSet;
    notifyListeners();
  }

  void _loadLanguage() async {
    try {
      var box = await Hive.openBox(_boxName);
      _currentLocal = box.get(_key, defaultValue: "en");
      await load(_currentLocal);
      notifyListeners();
    } catch (e) {
      print("Error loading language: $e");
      // Fallback to default language in case of error
      _currentLocal = "en";
      await load(_currentLocal);
      notifyListeners();
    }
  }

  Future<bool> changeLanguage(
      {required BuildContext context, required String locale}) async {
    try {
      _isLoading = true;
      notifyListeners();
      updateLangModel = await updateLangService.updateCurrentlang(
          context: context, lang: locale);
      if (updateLangModel?.success == true) {
        var box = await Hive.openBox(_boxName);
        await box.put(_key, locale);
        _localizedStrings = {};
        _currentLocal = locale; // Update current locale before loading
        await load(_currentLocal);
        _isLoading = false;
        notifyListeners();
        return true;
      }
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      print("Error changing language: $e");
      return false;
    }
  }

  Future<void> load(String locale) async {
    try {
      final String jsonString =
          await rootBundle.loadString('lib/arb/app_$locale.json');
      if (jsonString.isNotEmpty) {
        Map<String, dynamic> jsonMap = json.decode(jsonString);
        _localizedStrings = jsonMap.map((key, value) {
          return MapEntry(key, value.toString());
        });
      } else {
        print("Localization file is empty for locale: $locale");
      }
    } catch (e) {
      print("Error loading localization file: $e");
      // Fallback to default localization if loading fails
      _localizedStrings = {};
      await load("en");
    }
  }

  String translate(String key) {
    return _localizedStrings[key] ?? key;
  }
}
