import 'package:muvo/features/movies/domain/entities/movie.dart';
import 'package:muvo/features/movies/domain/repositories/movie_repository.dart';

class GetMoviesByGenre {
  final MovieRepository repository;

  GetMoviesByGenre(this.repository);

  Future<List<Movie>> call(int genreId, {int page = 1}) async {
    return await repository.getMoviesByGenre(genreId, page: page);
  }
} 