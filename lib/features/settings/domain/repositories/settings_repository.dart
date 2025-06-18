import 'package:firebase_auth/firebase_auth.dart';

abstract class SettingsRepository {
  Future<void> signOut();
  Future<void> setLanguage(String languageCode);
  String getCurrentLanguage();
  Future<User?> getCurrentUser();
} 