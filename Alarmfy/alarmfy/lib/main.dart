import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/theme/app_theme.dart';
import 'core/services/notification_service.dart';
import 'core/services/navigation_service.dart';
import 'data/datasources/alarm_local_datasource.dart';
import 'data/repositories/alarm_repository_impl.dart';
import 'core/router/app_router.dart';
import 'presentation/providers/alarm_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializar SharedPreferences
  final prefs = await SharedPreferences.getInstance();
  
  // Inicializar el servicio de notificaciones
  final notificationService = NotificationService();
  await notificationService.initialize();

  // Inicializar el datasource local
  final alarmLocalDataSource = AlarmLocalDataSourceImpl(prefs);

  // Inicializar el repositorio
  final alarmRepository = AlarmRepositoryImpl(alarmLocalDataSource);

  runApp(
    ProviderScope(
      overrides: [
        alarmRepositoryProvider.overrideWithValue(alarmRepository),
        notificationServiceProvider.overrideWithValue(notificationService),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Alarmfy',
      theme: AppTheme.darkTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.dark,
      routerConfig: router,
    );
  }
}
