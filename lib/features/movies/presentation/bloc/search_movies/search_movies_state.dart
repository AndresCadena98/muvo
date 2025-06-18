part of 'search_movies_bloc.dart';

abstract class SearchMoviesState extends Equatable {
  const SearchMoviesState();

  @override
  List<Object> get props => [];
}

class SearchMoviesInitial extends SearchMoviesState {}

class SearchMoviesLoading extends SearchMoviesState {}

class SearchMoviesEmpty extends SearchMoviesState {
  final String query;

  const SearchMoviesEmpty({required this.query});

  @override
  List<Object> get props => [query];
}

class SearchMoviesLoaded extends SearchMoviesState {
  final List<Movie> movies;

  const SearchMoviesLoaded({required this.movies});

  @override
  List<Object> get props => [movies];
}

class SearchMoviesError extends SearchMoviesState {
  final String message;
  final String query;

  const SearchMoviesError({
    required this.message,
    required this.query,
  });

  @override
  List<Object> get props => [message, query];
} 