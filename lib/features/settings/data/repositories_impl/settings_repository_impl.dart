import 'package:muvo/features/auth/domain/services/auth_service.dart';
import 'package:muvo/features/settings/domain/repositories/settings_repository.dart';
import 'package:muvo/core/services/language_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  final AuthService _authService;
  final LanguageService _languageService;

  SettingsRepositoryImpl({
    required AuthService authService,
    required LanguageService languageService,
  })  : _authService = authService,
        _languageService = languageService;

  @override
  Future<void> signOut() async {
    await _authService.signOut();
  }

  @override
  Future<void> setLanguage(String languageCode) async {
    await _languageService.setLanguage(languageCode);
  }

  @override
  String getCurrentLanguage() {
    return _languageService.currentLocale.languageCode;
  }

  @override
  Future<User?> getCurrentUser() async {
    return _authService.getCurrentUser();
  }
} 