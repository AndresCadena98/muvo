import 'package:get_it/get_it.dart';
import 'package:muvo/features/favorites/presentation/pages/favorites_page.dart';
import 'package:muvo/features/favorites/presentation/bloc/favorites/favorites_bloc.dart';
import 'package:muvo/features/favorites/data/repositories/favorites_repository_impl.dart';
import 'package:muvo/features/favorites/domain/repositories/favorites_repository.dart';

final getIt = GetIt.instance;

class FavoritesModule {
  static void init() {
    // Registramos la página
    getIt.registerFactory(() => const FavoritesPage());
  }
}

void setupFavoritesModule() {
  // Repositories
  getIt.registerLazySingleton<FavoritesRepository>(
    () => FavoritesRepositoryImpl(),
  );

  // Blocs
  getIt.registerFactory<FavoritesBloc>(
    () => FavoritesBloc(favoritesRepository: getIt<FavoritesRepository>()),
  );
} 