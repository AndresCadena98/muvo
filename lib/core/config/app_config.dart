import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConfig {
  static const String appName = 'Muvo';
  static const String apiBaseUrl = 'https://api.themoviedb.org/3';
  static String get tmdbApiKey {
    final apiKey = dotenv.env['TMDB_API_KEY'];
    if (apiKey == null || apiKey.isEmpty) {
      throw Exception('TMDB_API_KEY no está configurada en el archivo .env');
    }
    return apiKey;
  }
  
  // Theme Colors
  static const Color primaryColor = Color(0xFF00BFFF); // Azul brillante
  static const Color secondaryColor = Color(0xFF2E8B57); // Verde bosque
  static const Color accentColor = Color(0xFF00BFFF); // Azul profundo
  
  // Dark Theme Colors
  static const Color darkBackgroundColor = Color(0xFF121212); // Negro más oscuro
  static const Color darkSurfaceColor = Color(0xFF1E1E1E); // Gris más oscuro
  static const Color darkCardColor = Color(0xFF2D2D2D); // Gris medio
  static const Color darkTextPrimaryColor = Color(0xFFFFFFFF); // Blanco puro
  static const Color darkTextSecondaryColor = Color(0xFFB3B3B3); // Gris claro

  // Light Theme Colors
  static const Color lightBackgroundColor = Color(0xFFF5F5F5); // Blanco suave
  static const Color lightSurfaceColor = Color(0xFFFFFFFF); // Blanco puro
  static const Color lightCardColor = Color(0xFFF0F0F0); // Gris muy claro
  static const Color lightTextPrimaryColor = Color(0xFF000000); // Negro puro
  static const Color lightTextSecondaryColor = Color(0xFF666666); // Gris medio

  // Common Colors
  static const Color backgroundColor = darkBackgroundColor;
  static const Color surfaceColor = darkSurfaceColor;
  static const Color cardColor = darkCardColor;
  static const Color textPrimaryColor = darkTextPrimaryColor;
  static const Color textSecondaryColor = darkTextSecondaryColor;

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF7B68EE), Color(0xFF00BFFF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient darkBackgroundGradient = LinearGradient(
    colors: [Color(0xFF1A1A1A), Color(0xFF2D2D2D)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient lightBackgroundGradient = LinearGradient(
    colors: [Color(0xFFF5F5F5), Color(0xFFFFFFFF)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient darkCardGradient = LinearGradient(
    colors: [Color(0xFF363636), Color(0xFF2D2D2D)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient lightCardGradient = LinearGradient(
    colors: [Color(0xFFFFFFFF), Color(0xFFF0F0F0)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Text Styles
  static const TextStyle headingStyle = TextStyle(
    fontFamily: 'Poppins',
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: textPrimaryColor,
  );
  
  static const TextStyle bodyStyle = TextStyle(
    fontFamily: 'Poppins',
    fontSize: 16,
    color: textPrimaryColor,
  );

  static const Color white = Color(0xFFF5F5F5);
  static const Color black = Color(0xFF121212);
} 