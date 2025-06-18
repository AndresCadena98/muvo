import 'package:muvo/features/movies/domain/entities/movie.dart';
import 'package:muvo/features/movies/domain/repositories/movie_repository.dart';

class GetUpcomingMovies {
  final MovieRepository repository;

  GetUpcomingMovies(this.repository);

  Future<List<Movie>> call() async {
    return await repository.getUpcomingMovies();
  }
} 