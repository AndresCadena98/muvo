import 'package:muvo/features/movies/domain/entities/movie.dart';

abstract class FavoritesRepository {
  Stream<List<dynamic>> getFavorites();
  Future<void> addToFavorites(Movie movie);
  Future<void> removeFromFavorites(Movie movie);
  Future<bool> isFavorite(Movie movie);
} 