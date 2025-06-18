import 'package:get_it/get_it.dart';
import 'package:muvo/features/explore/presentation/pages/explore_page.dart';

final getIt = GetIt.instance;

class ExploreModule {
  static void init() {
    // Registramos la página
    getIt.registerFactory(() => const ExplorePage());
  }
} 