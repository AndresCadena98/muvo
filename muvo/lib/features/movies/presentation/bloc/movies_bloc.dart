import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muvo/features/movies/domain/usecases/get_popular_movies.dart';
import 'package:muvo/features/movies/presentation/bloc/movies_event.dart';
import 'package:muvo/features/movies/presentation/bloc/movies_state.dart';

class MoviesBloc extends Bloc<MoviesEvent, MoviesState> {
  final GetPopularMovies getPopularMovies;

  MoviesBloc({
    required this.getPopularMovies,
  }) : super(MoviesInitial()) {
    on<LoadPopularMovies>(_onLoadPopularMovies);
    on<LoadTopRatedMovies>(_onLoadTopRatedMovies);
    on<LoadUpcomingMovies>(_onLoadUpcomingMovies);
    on<SearchMovies>(_onSearchMovies);
  }

  Future<void> _onLoadPopularMovies(
    LoadPopularMovies event,
    Emitter<MoviesState> emit,
  ) async {
    emit(MoviesLoading());
    try {
      final movies = await getPopularMovies();
      emit(MoviesLoaded(movies));
    } catch (e) {
      emit(MoviesError(e.toString()));
    }
  }

  Future<void> _onLoadTopRatedMovies(
    LoadTopRatedMovies event,
    Emitter<MoviesState> emit,
  ) async {
    // TODO: Implementar
  }

  Future<void> _onLoadUpcomingMovies(
    LoadUpcomingMovies event,
    Emitter<MoviesState> emit,
  ) async {
    // TODO: Implementar
  }

  Future<void> _onSearchMovies(
    SearchMovies event,
    Emitter<MoviesState> emit,
  ) async {
    // TODO: Implementar
  }
} 