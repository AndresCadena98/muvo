import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageService extends ChangeNotifier {
  static const String _languageKey = 'language_code';
  final SharedPreferences _prefs;
  
  LanguageService(this._prefs);
  
  Locale get currentLocale {
    final languageCode = _prefs.getString(_languageKey) ?? 'es';
    return Locale(languageCode);
  }
  
  String get currentLanguageCode => currentLocale.languageCode;
  
  Future<void> setLanguage(String languageCode) async {
    await _prefs.setString(_languageKey, languageCode);
    notifyListeners();
  }
  
  static Future<LanguageService> create() async {
    final prefs = await SharedPreferences.getInstance();
    return LanguageService(prefs);
  }
} 