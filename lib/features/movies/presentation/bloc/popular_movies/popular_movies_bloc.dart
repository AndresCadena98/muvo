import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:muvo/features/movies/domain/entities/movie.dart';
import 'package:muvo/features/movies/domain/usecases/get_popular_movies.dart';

part 'popular_movies_event.dart';
part 'popular_movies_state.dart';

class PopularMoviesBloc extends Bloc<PopularMoviesEvent, PopularMoviesState> {
  final GetPopularMovies getPopularMovies;
  int _currentPage = 1;
  static const int _pageSize = 20;

  PopularMoviesBloc({
    required this.getPopularMovies,
  }) : super(PopularMoviesInitial()) {
    on<LoadPopularMovies>(_onLoadPopularMovies);
    on<LoadMorePopularMovies>(_onLoadMorePopularMovies);
    on<RefreshPopularMovies>(_onRefreshPopularMovies);
  }

  Future<void> _onLoadPopularMovies(
    LoadPopularMovies event,
    Emitter<PopularMoviesState> emit,
  ) async {
    _currentPage = 1;
    emit(PopularMoviesLoading());

    try {
      final movies = await getPopularMovies(page: _currentPage);
      emit(PopularMoviesLoaded(
        movies: movies,
        hasReachedMax: movies.length < _pageSize,
      ));
    } catch (e) {
      emit(PopularMoviesError(message: e.toString()));
    }
  }

  Future<void> _onLoadMorePopularMovies(
    LoadMorePopularMovies event,
    Emitter<PopularMoviesState> emit,
  ) async {
    if (state is PopularMoviesLoaded) {
      final currentState = state as PopularMoviesLoaded;
      if (currentState.hasReachedMax) return;

      try {
        _currentPage++;
        final newMovies = await getPopularMovies(page: _currentPage);
        
        emit(PopularMoviesLoaded(
          movies: [...currentState.movies, ...newMovies],
          hasReachedMax: newMovies.length < _pageSize,
        ));
      } catch (e) {
        emit(PopularMoviesError(message: e.toString()));
      }
    }
  }

  Future<void> _onRefreshPopularMovies(
    RefreshPopularMovies event,
    Emitter<PopularMoviesState> emit,
  ) async {
    _currentPage = 1;
    try {
      final movies = await getPopularMovies(page: _currentPage);
      emit(PopularMoviesLoaded(
        movies: movies,
        hasReachedMax: movies.length < _pageSize,
      ));
    } catch (e) {
      emit(PopularMoviesError(message: e.toString()));
    }
  }
} 