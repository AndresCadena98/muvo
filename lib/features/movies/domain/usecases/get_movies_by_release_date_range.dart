import 'package:muvo/features/movies/domain/entities/movie.dart';
import 'package:muvo/features/movies/domain/repositories/movie_repository.dart';

class GetMoviesByReleaseDateRange {
  final MovieRepository repository;

  GetMoviesByReleaseDateRange(this.repository);

  Future<List<Movie>> call(DateTime startDate, DateTime endDate) async {
    return await repository.getMoviesByReleaseDateRange(startDate, endDate);
  }
} 