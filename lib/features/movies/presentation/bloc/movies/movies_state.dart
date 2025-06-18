part of 'movies_bloc.dart';

abstract class MoviesState extends Equatable {
  const MoviesState();

  @override
  List<Object> get props => [];
}

class MoviesInitial extends MoviesState {}

class MoviesLoading extends MoviesState {}

class MoviesLoaded extends MoviesState {
  final List<Movie> popularMovies;
  final List<Movie> topRatedMovies;
  final List<Movie> upcomingMovies;
  final List<Movie> searchResults;

  const MoviesLoaded({
    required this.popularMovies,
    required this.topRatedMovies,
    required this.upcomingMovies,
    required this.searchResults,
  });

  @override
  List<Object> get props => [popularMovies, topRatedMovies, upcomingMovies, searchResults];
}

class MoviesError extends MoviesState {
  final String message;

  const MoviesError({required this.message});

  @override
  List<Object> get props => [message];
} 