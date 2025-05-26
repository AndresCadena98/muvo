import 'package:muvo/features/movies/domain/entities/movie.dart';
import 'package:muvo/features/movies/domain/repositories/movie_repository.dart';

class GetPopularMovies {
  final MovieRepository repository;

  GetPopularMovies(this.repository);

  Future<List<Movie>> call() async {
    return await repository.getPopularMovies();
  }
} 