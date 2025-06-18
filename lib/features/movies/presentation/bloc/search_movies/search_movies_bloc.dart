import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:muvo/features/movies/domain/entities/movie.dart';
import 'package:muvo/features/movies/domain/repositories/movie_repository.dart';

part 'search_movies_event.dart';
part 'search_movies_state.dart';

class SearchMoviesBloc extends Bloc<SearchMoviesEvent, SearchMoviesState> {
  final MovieRepository movieRepository;
  Timer? _debounce;

  SearchMoviesBloc({
    required this.movieRepository,
  }) : super(SearchMoviesInitial()) {
    on<SearchMoviesQueryChanged>(_onSearchMoviesQueryChanged);
    on<SearchMoviesCleared>(_onSearchMoviesCleared);
  }

  Future<void> _onSearchMoviesQueryChanged(
    SearchMoviesQueryChanged event,
    Emitter<SearchMoviesState> emit,
  ) async {
    if (event.query.isEmpty) {
      emit(SearchMoviesInitial());
      return;
    }

    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(milliseconds: 500), () async {
      emit(SearchMoviesLoading());

      try {
        final movies = await movieRepository.searchMovies(event.query);
        if (movies.isEmpty) {
          emit(SearchMoviesEmpty(query: event.query));
        } else {
          emit(SearchMoviesLoaded(movies: movies));
        }
      } catch (e) {
        emit(SearchMoviesError(
          message: e.toString(),
          query: event.query,
        ));
      }
    });
  }

  void _onSearchMoviesCleared(
    SearchMoviesCleared event,
    Emitter<SearchMoviesState> emit,
  ) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    emit(SearchMoviesInitial());
  }

  @override
  Future<void> close() {
    _debounce?.cancel();
    return super.close();
  }
} 