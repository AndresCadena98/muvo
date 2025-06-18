import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeService {
  static const String _themeKey = 'theme_mode';
  final SharedPreferences _prefs;

  ThemeService(this._prefs);

  ThemeMode getThemeMode() {
    return ThemeMode.dark;
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    await _prefs.setString(_themeKey, mode.toString());
  }
} 