import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muvo/features/settings/domain/repositories/settings_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Estados
abstract class SettingsState {}

class SettingsInitial extends SettingsState {}

class SettingsLoading extends SettingsState {}

class SettingsError extends SettingsState {
  final String message;
  SettingsError(this.message);
}

class SettingsSuccess extends SettingsState {}

class SettingsLoaded extends SettingsState {
  final User? user;
  SettingsLoaded(this.user);
}

class SettingsUnauthenticated extends SettingsState {}

// Cubit
class SettingsCubit extends Cubit<SettingsState> {
  final SettingsRepository _settingsRepository;

  SettingsCubit(this._settingsRepository) : super(SettingsInitial()) {
    _loadUserInfo();
  }

  Future<void> _loadUserInfo() async {
    try {
      emit(SettingsLoading());
      final user = await _settingsRepository.getCurrentUser();
      emit(SettingsLoaded(user));
    } catch (e) {
      emit(SettingsError(e.toString()));
    }
  }

  Future<void> signOut() async {
    try {
      await _settingsRepository.signOut();
      emit(SettingsUnauthenticated());
    } catch (e) {
      emit(SettingsError(e.toString()));
    }
  }

  Future<void> setLanguage(String languageCode) async {
    try {
      emit(SettingsLoading());
      await _settingsRepository.setLanguage(languageCode);
      final user = await _settingsRepository.getCurrentUser();
      emit(SettingsLoaded(user));
    } catch (e) {
      emit(SettingsError(e.toString()));
    }
  }

  String getCurrentLanguage() {
    return _settingsRepository.getCurrentLanguage();
  }
} 