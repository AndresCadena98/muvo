import 'package:muvo/features/movies/domain/entities/movie.dart';
import 'package:muvo/features/movies/domain/entities/movie_review.dart';
import 'package:muvo/features/movies/domain/entities/movie_credit.dart';
import 'package:muvo/features/movies/domain/entities/movie_video.dart';

abstract class MovieRepository {
  Future<List<Movie>> getPopularMovies({int page = 1});
  Future<List<Movie>> getTopRatedMovies({int page = 1});
  Future<List<Movie>> getUpcomingMovies({int page = 1});
  Future<Movie> getMovieDetails(int id);
  Future<List<Movie>> searchMovies(String query, {int page = 1});
  Future<List<Movie>> getNowPlayingMovies({int page = 1});
  Future<List<Movie>> getSimilarMovies(int movieId, {int page = 1});
  Future<List<Movie>> getRecommendations(int movieId, {int page = 1});
  Future<List<MovieCredit>> getMovieCredits(int movieId);
  Future<List<MovieVideo>> getMovieVideos(int movieId);
  Future<List<MovieReview>> getMovieReviews(int movieId, {int page = 1});
  Future<List<Movie>> getMoviesByGenre(int genreId, {int page = 1});
  Future<List<Movie>> getMoviesByYear(int year, {int page = 1});
  Future<List<Movie>> getMoviesByLanguage(String language, {int page = 1});
  Future<List<Movie>> getMoviesByRegion(String region, {int page = 1});
  Future<List<Movie>> getMoviesByReleaseDateRange(DateTime startDate, DateTime endDate, {int page = 1});
} 