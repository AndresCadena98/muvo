import 'package:muvo/features/movies/domain/entities/movie.dart';
import 'package:muvo/features/movies/domain/repositories/movie_repository.dart';

class GetMoviesByLanguage {
  final MovieRepository repository;

  GetMoviesByLanguage(this.repository);

  Future<List<Movie>> call(String language) async {
    return await repository.getMoviesByLanguage(language);
  }
} 