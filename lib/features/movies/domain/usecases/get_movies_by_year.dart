import 'package:muvo/features/movies/domain/entities/movie.dart';
import 'package:muvo/features/movies/domain/repositories/movie_repository.dart';

class GetMoviesByYear {
  final MovieRepository repository;

  GetMoviesByYear(this.repository);

  Future<List<Movie>> call(int year) async {
    return await repository.getMoviesByYear(year);
  }
} 