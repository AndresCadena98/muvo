import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:muvo/features/movies/domain/entities/movie.dart';
import 'package:muvo/features/movies/domain/usecases/get_popular_movies.dart';
import 'package:muvo/features/movies/domain/usecases/get_top_rated_movies.dart';
import 'package:muvo/features/movies/domain/usecases/get_upcoming_movies.dart';
import 'package:muvo/features/movies/domain/usecases/get_movies_by_genre.dart';
import 'package:muvo/features/movies/domain/usecases/search_movies.dart';

part 'movies_event.dart';
part 'movies_state.dart';

class MoviesBloc extends Bloc<MoviesEvent, MoviesState> {
  final GetPopularMovies getPopularMovies;
  final GetTopRatedMovies getTopRatedMovies;
  final GetUpcomingMovies getUpcomingMovies;
  final GetMoviesByGenre getMoviesByGenre;
  final SearchMoviesUseCase searchMovies;

  MoviesBloc({
    required this.getPopularMovies,
    required this.getTopRatedMovies,
    required this.getUpcomingMovies,
    required this.getMoviesByGenre,
    required this.searchMovies,
  }) : super(MoviesInitial()) {
    on<LoadMovies>(_onLoadMovies);
    on<LoadMoviesByGenre>(_onLoadMoviesByGenre);
    on<SearchMovies>(_onSearchMovies);
  }

  Future<void> _onLoadMovies(
    LoadMovies event,
    Emitter<MoviesState> emit,
  ) async {
    emit(MoviesLoading());

    try {
      final popularMovies = await getPopularMovies();
      final topRatedMovies = await getTopRatedMovies();
      final upcomingMovies = await getUpcomingMovies();

      emit(MoviesLoaded(
        popularMovies: popularMovies,
        topRatedMovies: topRatedMovies,
        upcomingMovies: upcomingMovies,
        searchResults: [],
      ));
    } catch (e) {
      emit(MoviesError(message: e.toString()));
    }
  }

  Future<void> _onLoadMoviesByGenre(
    LoadMoviesByGenre event,
    Emitter<MoviesState> emit,
  ) async {
    emit(MoviesLoading());

    try {
      final movies = await getMoviesByGenre(event.genreId);
      emit(MoviesLoaded(
        popularMovies: movies,
        topRatedMovies: [],
        upcomingMovies: [],
        searchResults: [],
      ));
    } catch (e) {
      emit(MoviesError(message: e.toString()));
    }
  }

  Future<void> _onSearchMovies(
    SearchMovies event,
    Emitter<MoviesState> emit,
  ) async {
    if (event.page == 1) {
      emit(MoviesLoading());
    }

    try {
      final results = await searchMovies(event.query, page: event.page);
      
      if (state is MoviesLoaded && event.page > 1) {
        final currentState = state as MoviesLoaded;
        emit(MoviesLoaded(
          popularMovies: currentState.popularMovies,
          topRatedMovies: currentState.topRatedMovies,
          upcomingMovies: currentState.upcomingMovies,
          searchResults: [...currentState.searchResults, ...results],
        ));
      } else {
        emit(MoviesLoaded(
          popularMovies: [],
          topRatedMovies: [],
          upcomingMovies: [],
          searchResults: results,
        ));
      }
    } catch (e) {
      emit(MoviesError(message: e.toString()));
    }
  }
} 