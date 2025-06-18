import 'package:get_it/get_it.dart';
import 'package:muvo/features/movies/di/movies_module.dart';

final getIt = GetIt.instance;

class InjectionContainer {
  static Future<void> init() async {
    // Inicializar módulos
    await setupDependencies();
  }

  static Future<void> setupDependencies() async {
    // Inicializar módulos de la aplicación
    await setupMoviesModule();
  }
} 