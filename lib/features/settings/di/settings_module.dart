import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:muvo/features/settings/domain/services/theme_service.dart';
import 'package:muvo/features/settings/presentation/bloc/theme_bloc.dart';
import 'package:muvo/features/auth/domain/services/auth_service.dart';
import 'package:muvo/core/services/language_service.dart';
import 'package:muvo/features/settings/data/repositories_impl/settings_repository_impl.dart';
import 'package:muvo/features/settings/domain/repositories/settings_repository.dart';
import 'package:muvo/features/settings/presentation/cubit/settings_cubit.dart';

Future<void> setupSettingsModule() async {
  final getIt = GetIt.instance;
  
  // Services
  final prefs = await SharedPreferences.getInstance();
  getIt.registerLazySingleton<ThemeService>(() => ThemeService(prefs));
  
  // Repositories
  getIt.registerLazySingleton<SettingsRepository>(
    () => SettingsRepositoryImpl(
      authService: getIt<AuthService>(),
      languageService: getIt<LanguageService>(),
    ),
  );
  
  // Blocs
  getIt.registerFactory<ThemeBloc>(
    () => ThemeBloc(getIt<ThemeService>()),
  );
  
  // Cubits
  getIt.registerFactory<SettingsCubit>(
    () => SettingsCubit(getIt<SettingsRepository>()),
  );
} 