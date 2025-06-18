import 'package:get_it/get_it.dart';
import 'package:muvo/core/config/app_config.dart';
import 'package:muvo/core/services/language_service.dart';
import 'package:muvo/features/movies/data/datasources/movie_remote_data_source.dart';
import 'package:muvo/features/movies/data/repositories/movie_repository_impl.dart';
import 'package:muvo/features/movies/domain/repositories/movie_repository.dart';
import 'package:muvo/features/movies/domain/usecases/get_popular_movies.dart';
import 'package:muvo/features/movies/domain/usecases/get_top_rated_movies.dart';
import 'package:muvo/features/movies/domain/usecases/get_upcoming_movies.dart';
import 'package:muvo/features/movies/domain/usecases/get_movies_by_genre.dart';
import 'package:muvo/features/movies/domain/usecases/search_movies.dart';
import 'package:muvo/features/movies/presentation/bloc/movies/movies_bloc.dart';
import 'package:muvo/features/movies/presentation/bloc/popular_movies/popular_movies_bloc.dart';
import 'package:muvo/features/movies/presentation/bloc/search_movies/search_movies_bloc.dart';
import 'package:muvo/features/movies/presentation/bloc/movie_details/movie_details_bloc.dart';
import 'package:dio/dio.dart';

Future<void> setupMoviesModule() async {
  // Data sources
  GetIt.I.registerLazySingleton<MovieRemoteDataSource>(
    () => MovieRemoteDataSourceImpl(
      dio: Dio(
        BaseOptions(
          baseUrl: 'https://api.themoviedb.org/3',
          queryParameters: {
            'api_key': AppConfig.tmdbApiKey,
            'language': GetIt.I<LanguageService>().currentLanguageCode,
          },
        ),
      ),
      languageService: GetIt.I<LanguageService>(),
    ),
  );

  // Repositories
  GetIt.I.registerLazySingleton<MovieRepository>(
    () => MovieRepositoryImpl(
      remoteDataSource: GetIt.I<MovieRemoteDataSource>(),
    ),
  );

  // Use cases
  GetIt.I.registerLazySingleton(() => GetPopularMovies(GetIt.I<MovieRepository>()));
  GetIt.I.registerLazySingleton(() => GetTopRatedMovies(GetIt.I<MovieRepository>()));
  GetIt.I.registerLazySingleton(() => GetUpcomingMovies(GetIt.I<MovieRepository>()));
  GetIt.I.registerLazySingleton(() => GetMoviesByGenre(GetIt.I<MovieRepository>()));
  GetIt.I.registerLazySingleton(() => SearchMoviesUseCase(GetIt.I<MovieRepository>()));

  // BLoCs
  GetIt.I.registerFactory(() => MoviesBloc(
        getPopularMovies: GetIt.I<GetPopularMovies>(),
        getTopRatedMovies: GetIt.I<GetTopRatedMovies>(),
        getUpcomingMovies: GetIt.I<GetUpcomingMovies>(),
        getMoviesByGenre: GetIt.I<GetMoviesByGenre>(),
        searchMovies: GetIt.I<SearchMoviesUseCase>(),
      ));

  GetIt.I.registerFactory(() => PopularMoviesBloc(
        getPopularMovies: GetIt.I<GetPopularMovies>(),
      ));

  GetIt.I.registerFactory(() => SearchMoviesBloc(
        movieRepository: GetIt.I<MovieRepository>(),
      ));

  GetIt.I.registerFactory(() => MovieDetailsBloc(
        movieRepository: GetIt.I<MovieRepository>(),
      ));
} 