import 'package:flutter/material.dart';
import 'package:muvo/core/config/env_config.dart';

class AppConfig {
  static const String appName = 'Muvo';
  static const String apiBaseUrl = 'https://api.themoviedb.org/3';
  static String get apiKey => EnvConfig.apiKey;
  
  // Theme
  static const Color primaryColor = Color(0xFF1A1A1A);
  static const Color accentColor = Color(0xFFE50914);
  static const Color backgroundColor = Color(0xFF000000);
  static const Color surfaceColor = Color(0xFF1F1F1F);
  
  // Text Styles
  static const TextStyle headingStyle = TextStyle(
    fontFamily: 'Poppins',
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );
  
  static const TextStyle bodyStyle = TextStyle(
    fontFamily: 'Poppins',
    fontSize: 16,
    color: Colors.white70,
  );
} 