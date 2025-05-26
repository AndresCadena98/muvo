import 'package:muvo/features/movies/domain/entities/movie.dart';

abstract class MovieRepository {
  Future<List<Movie>> getPopularMovies();
  Future<List<Movie>> getTopRatedMovies();
  Future<List<Movie>> getUpcomingMovies();
  Future<Movie> getMovieDetails(int id);
  Future<List<Movie>> searchMovies(String query);
} 