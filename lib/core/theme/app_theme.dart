import 'package:flutter/material.dart';
import '../config/app_config.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.light(
        primary: AppConfig.primaryColor,
        secondary: AppConfig.secondaryColor,
        surface: AppConfig.lightSurfaceColor,
        background: AppConfig.lightBackgroundColor,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: AppConfig.lightTextPrimaryColor,
        onBackground: AppConfig.lightTextPrimaryColor,
      ),
      scaffoldBackgroundColor: AppConfig.lightBackgroundColor,
      cardTheme: CardTheme(
        color: AppConfig.lightCardColor,
        elevation: 2,
        shadowColor: Colors.black.withOpacity(0.1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppConfig.lightSurfaceColor,
        foregroundColor: AppConfig.lightTextPrimaryColor,
        elevation: 0,
        shadowColor: Colors.black.withOpacity(0.1),
      ),
      textTheme: TextTheme(
        displayLarge: AppConfig.headingStyle.copyWith(
          color: AppConfig.lightTextPrimaryColor,
        ),
        bodyLarge: AppConfig.bodyStyle.copyWith(
          color: AppConfig.lightTextPrimaryColor,
        ),
        bodyMedium: AppConfig.bodyStyle.copyWith(
          color: AppConfig.lightTextSecondaryColor,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppConfig.primaryColor,
          foregroundColor: Colors.white,
          elevation: 2,
          shadowColor: Colors.black.withOpacity(0.2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppConfig.lightSurfaceColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: AppConfig.lightTextSecondaryColor.withOpacity(0.2),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: AppConfig.lightTextSecondaryColor.withOpacity(0.2),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: AppConfig.primaryColor,
          ),
        ),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.dark(
        primary: AppConfig.primaryColor,
        secondary: AppConfig.secondaryColor,
        surface: AppConfig.darkSurfaceColor,
        background: AppConfig.darkBackgroundColor,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: AppConfig.darkTextPrimaryColor,
        onBackground: AppConfig.darkTextPrimaryColor,
      ),
      scaffoldBackgroundColor: AppConfig.darkBackgroundColor,
      cardTheme: CardTheme(
        color: AppConfig.darkCardColor,
        elevation: 2,
        shadowColor: Colors.black.withOpacity(0.3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppConfig.darkSurfaceColor,
        foregroundColor: AppConfig.darkTextPrimaryColor,
        elevation: 0,
        shadowColor: Colors.black.withOpacity(0.3),
      ),
      textTheme: TextTheme(
        displayLarge: AppConfig.headingStyle.copyWith(
          color: AppConfig.darkTextPrimaryColor,
        ),
        bodyLarge: AppConfig.bodyStyle.copyWith(
          color: AppConfig.darkTextPrimaryColor,
        ),
        bodyMedium: AppConfig.bodyStyle.copyWith(
          color: AppConfig.darkTextSecondaryColor,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppConfig.primaryColor,
          foregroundColor: Colors.white,
          elevation: 2,
          shadowColor: Colors.black.withOpacity(0.4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppConfig.darkSurfaceColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: AppConfig.darkTextSecondaryColor.withOpacity(0.2),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: AppConfig.darkTextSecondaryColor.withOpacity(0.2),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: AppConfig.primaryColor,
          ),
        ),
      ),
    );
  }
} 