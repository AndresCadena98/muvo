import 'package:muvo/features/movies/domain/entities/movie_review.dart';
import 'package:muvo/features/movies/domain/repositories/movie_repository.dart';

class GetMovieReviews {
  final MovieRepository repository;

  GetMovieReviews(this.repository);

  Future<List<MovieReview>> call(int movieId) async {
    return await repository.getMovieReviews(movieId);
  }
} 