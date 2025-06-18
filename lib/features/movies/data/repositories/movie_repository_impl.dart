import 'package:muvo/features/movies/data/datasources/movie_remote_data_source.dart';
import 'package:muvo/features/movies/domain/entities/movie.dart';
import 'package:muvo/features/movies/domain/entities/movie_review.dart';
import 'package:muvo/features/movies/domain/entities/movie_credit.dart';
import 'package:muvo/features/movies/domain/entities/movie_video.dart';
import 'package:muvo/features/movies/domain/repositories/movie_repository.dart';

class MovieRepositoryImpl implements MovieRepository {
  final MovieRemoteDataSource remoteDataSource;

  MovieRepositoryImpl({
    required this.remoteDataSource,
  });

  @override
  Future<List<Movie>> getPopularMovies({int page = 1}) async {
    return await remoteDataSource.getPopularMovies(page: page);
  }

  @override
  Future<List<Movie>> getTopRatedMovies({int page = 1}) async {
    return await remoteDataSource.getTopRatedMovies(page: page);
  }

  @override
  Future<List<Movie>> getUpcomingMovies({int page = 1}) async {
    return await remoteDataSource.getUpcomingMovies(page: page);
  }

  @override
  Future<Movie> getMovieDetails(int id) async {
    return await remoteDataSource.getMovieDetails(id);
  }

  @override
  Future<List<Movie>> searchMovies(String query, {int page = 1}) async {
    return await remoteDataSource.searchMovies(query, page: page);
  }

  @override
  Future<List<Movie>> getNowPlayingMovies({int page = 1}) async {
    return await remoteDataSource.getNowPlayingMovies(page: page);
  }

  @override
  Future<List<Movie>> getSimilarMovies(int movieId, {int page = 1}) async {
    return await remoteDataSource.getSimilarMovies(movieId, page: page);
  }

  @override
  Future<List<Movie>> getRecommendations(int movieId, {int page = 1}) async {
    return await remoteDataSource.getRecommendations(movieId, page: page);
  }

  @override
  Future<List<MovieCredit>> getMovieCredits(int movieId) async {
    return await remoteDataSource.getMovieCredits(movieId);
  }

  @override
  Future<List<MovieVideo>> getMovieVideos(int movieId) async {
    return await remoteDataSource.getMovieVideos(movieId);
  }

  @override
  Future<List<MovieReview>> getMovieReviews(int movieId, {int page = 1}) async {
    return await remoteDataSource.getMovieReviews(movieId, page: page);
  }

  @override
  Future<List<Movie>> getMoviesByGenre(int genreId, {int page = 1}) async {
    return await remoteDataSource.getMoviesByGenre(genreId, page: page);
  }

  @override
  Future<List<Movie>> getMoviesByYear(int year, {int page = 1}) async {
    return await remoteDataSource.getMoviesByYear(year, page: page);
  }

  @override
  Future<List<Movie>> getMoviesByLanguage(String language, {int page = 1}) async {
    return await remoteDataSource.getMoviesByLanguage(language, page: page);
  }

  @override
  Future<List<Movie>> getMoviesByRegion(String region, {int page = 1}) async {
    return await remoteDataSource.getMoviesByRegion(region, page: page);
  }

  @override
  Future<List<Movie>> getMoviesByReleaseDateRange(DateTime startDate, DateTime endDate, {int page = 1}) async {
    return await remoteDataSource.getMoviesByReleaseDateRange(startDate, endDate, page: page);
  }
} 