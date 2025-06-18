import 'package:muvo/features/movies/domain/entities/movie.dart';
import 'package:muvo/features/movies/domain/repositories/movie_repository.dart';

class SearchMoviesUseCase {
  final MovieRepository repository;

  SearchMoviesUseCase(this.repository);

  Future<List<Movie>> call(String query, {int page = 1}) async {
    return await repository.searchMovies(query, page: page);
  }
} 