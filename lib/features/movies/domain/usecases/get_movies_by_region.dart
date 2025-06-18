import 'package:muvo/features/movies/domain/entities/movie.dart';
import 'package:muvo/features/movies/domain/repositories/movie_repository.dart';

class GetMoviesByRegion {
  final MovieRepository repository;

  GetMoviesByRegion(this.repository);

  Future<List<Movie>> call(String region) async {
    return await repository.getMoviesByRegion(region);
  }
} 