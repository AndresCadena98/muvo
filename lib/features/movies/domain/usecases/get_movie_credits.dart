import 'package:muvo/features/movies/domain/entities/movie.dart';
import 'package:muvo/features/movies/domain/entities/movie_credit.dart';
import 'package:muvo/features/movies/domain/repositories/movie_repository.dart';

class GetMovieCredits {
  final MovieRepository repository;

  GetMovieCredits(this.repository);

  Future<List<MovieCredit>> call(int movieId) async {
    return await repository.getMovieCredits(movieId);
  }
} 