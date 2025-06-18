import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:muvo/core/services/language_service.dart';
import 'package:muvo/features/movies/data/models/movie_model.dart';
import 'package:muvo/features/movies/data/models/movie_review_model.dart';
import 'package:muvo/features/movies/data/models/movie_credit_model.dart';
import 'package:muvo/features/movies/data/models/movie_video_model.dart';
import 'package:muvo/features/movies/domain/entities/movie.dart';
import 'package:muvo/features/movies/domain/entities/movie_review.dart';
import 'package:muvo/features/movies/domain/entities/movie_credit.dart';
import 'package:muvo/features/movies/domain/entities/movie_video.dart';

abstract class MovieRemoteDataSource {
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
  void updateLanguage(String languageCode);
}

class MovieRemoteDataSourceImpl implements MovieRemoteDataSource {
  final Dio dio;
  final String baseUrl = 'https://api.themoviedb.org/3';
  final String apiKey = dotenv.env['TMDB_API_KEY'] ?? '';
  final LanguageService _languageService;

  MovieRemoteDataSourceImpl({
    required this.dio,
    required LanguageService languageService,
  }) : _languageService = languageService {
    _languageService.addListener(_onLanguageChanged);
  }

  void _onLanguageChanged() {
    dio.options.queryParameters['language'] = _languageService.currentLanguageCode;
  }

  @override
  void updateLanguage(String languageCode) {
    dio.options.queryParameters['language'] = languageCode;
  }

  @override
  Future<List<Movie>> getPopularMovies({int page = 1}) async {
    final response = await dio.get(
      '$baseUrl/movie/popular',
      queryParameters: {
        'api_key': apiKey,
        'page': page,
      },
    );
    return (response.data['results'] as List)
        .map((json) => MovieModel.fromJson(json))
        .toList();
  }

  @override
  Future<List<Movie>> getTopRatedMovies({int page = 1}) async {
    final response = await dio.get(
      '$baseUrl/movie/top_rated',
      queryParameters: {
        'api_key': apiKey,
        'page': page,
      },
    );
    return (response.data['results'] as List)
        .map((json) => MovieModel.fromJson(json))
        .toList();
  }

  @override
  Future<List<Movie>> getUpcomingMovies({int page = 1}) async {
    final response = await dio.get(
      '$baseUrl/movie/upcoming',
      queryParameters: {
        'api_key': apiKey,
        'page': page,
      },
    );
    return (response.data['results'] as List)
        .map((json) => MovieModel.fromJson(json))
        .toList();
  }

  @override
  Future<Movie> getMovieDetails(int id) async {
    final response = await dio.get(
      '$baseUrl/movie/$id',
      queryParameters: {
        'api_key': apiKey,
      },
    );
    return MovieModel.fromJson(response.data);
  }

  @override
  Future<List<Movie>> searchMovies(String query, {int page = 1}) async {
    final response = await dio.get(
      '$baseUrl/search/movie',
      queryParameters: {
        'api_key': apiKey,
        'query': query,
        'page': page,
      },
    );
    return (response.data['results'] as List)
        .map((json) => MovieModel.fromJson(json))
        .toList();
  }

  @override
  Future<List<Movie>> getNowPlayingMovies({int page = 1}) async {
    final response = await dio.get(
      '$baseUrl/movie/now_playing',
      queryParameters: {
        'api_key': apiKey,
        'page': page,
      },
    );
    return (response.data['results'] as List)
        .map((json) => MovieModel.fromJson(json))
        .toList();
  }

  @override
  Future<List<Movie>> getSimilarMovies(int movieId, {int page = 1}) async {
    final response = await dio.get(
      '$baseUrl/movie/$movieId/similar',
      queryParameters: {
        'api_key': apiKey,
        'page': page,
      },
    );
    return (response.data['results'] as List)
        .map((json) => MovieModel.fromJson(json))
        .toList();
  }

  @override
  Future<List<Movie>> getRecommendations(int movieId, {int page = 1}) async {
    final response = await dio.get(
      '$baseUrl/movie/$movieId/recommendations',
      queryParameters: {
        'api_key': apiKey,
        'page': page,
      },
    );
    return (response.data['results'] as List)
        .map((json) => MovieModel.fromJson(json))
        .toList();
  }

  @override
  Future<List<MovieCredit>> getMovieCredits(int movieId) async {
    final response = await dio.get(
      '$baseUrl/movie/$movieId/credits',
      queryParameters: {
        'api_key': apiKey,
      },
    );
    return (response.data['cast'] as List)
        .map((json) => MovieCreditModel.fromJson(json))
        .toList();
  }

  @override
  Future<List<MovieVideo>> getMovieVideos(int movieId) async {
    final response = await dio.get(
      '$baseUrl/movie/$movieId/videos',
      queryParameters: {
        'api_key': apiKey,
      },
    );
    return (response.data['results'] as List)
        .map((json) => MovieVideoModel.fromJson(json))
        .toList();
  }

  @override
  Future<List<MovieReview>> getMovieReviews(int movieId, {int page = 1}) async {
    final response = await dio.get(
      '$baseUrl/movie/$movieId/reviews',
      queryParameters: {
        'api_key': apiKey,
        'page': page,
      },
    );
    return (response.data['results'] as List)
        .map((json) => MovieReviewModel.fromJson(json))
        .toList();
  }

  @override
  Future<List<Movie>> getMoviesByGenre(int genreId, {int page = 1}) async {
    final response = await dio.get(
      '$baseUrl/discover/movie',
      queryParameters: {
        'api_key': apiKey,
        'with_genres': genreId,
        'page': page,
      },
    );
    return (response.data['results'] as List)
        .map((json) => MovieModel.fromJson(json))
        .toList();
  }

  @override
  Future<List<Movie>> getMoviesByYear(int year, {int page = 1}) async {
    final response = await dio.get(
      '$baseUrl/discover/movie',
      queryParameters: {
        'api_key': apiKey,
        'primary_release_year': year,
        'page': page,
      },
    );
    return (response.data['results'] as List)
        .map((json) => MovieModel.fromJson(json))
        .toList();
  }

  @override
  Future<List<Movie>> getMoviesByLanguage(String language, {int page = 1}) async {
    final response = await dio.get(
      '$baseUrl/discover/movie',
      queryParameters: {
        'api_key': apiKey,
        'with_original_language': language,
        'page': page,
      },
    );
    return (response.data['results'] as List)
        .map((json) => MovieModel.fromJson(json))
        .toList();
  }

  @override
  Future<List<Movie>> getMoviesByRegion(String region, {int page = 1}) async {
    final response = await dio.get(
      '$baseUrl/discover/movie',
      queryParameters: {
        'api_key': apiKey,
        'region': region,
        'page': page,
      },
    );
    return (response.data['results'] as List)
        .map((json) => MovieModel.fromJson(json))
        .toList();
  }

  @override
  Future<List<Movie>> getMoviesByReleaseDateRange(DateTime startDate, DateTime endDate, {int page = 1}) async {
    final response = await dio.get(
      '$baseUrl/discover/movie',
      queryParameters: {
        'api_key': apiKey,
        'primary_release_date.gte': startDate.toIso8601String().split('T')[0],
        'primary_release_date.lte': endDate.toIso8601String().split('T')[0],
        'page': page,
      },
    );
    return (response.data['results'] as List)
        .map((json) => MovieModel.fromJson(json))
        .toList();
  }
} 