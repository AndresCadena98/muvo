part of 'popular_movies_bloc.dart';


abstract class PopularMoviesState extends Equatable {
  const PopularMoviesState();

  @override
  List<Object> get props => [];
}

class PopularMoviesInitial extends PopularMoviesState {}

class PopularMoviesLoading extends PopularMoviesState {}

class PopularMoviesLoaded extends PopularMoviesState {
  final List<Movie> movies;
  final bool hasReachedMax;

  const PopularMoviesLoaded({
    required this.movies,
    this.hasReachedMax = false,
  });

  @override
  List<Object> get props => [movies, hasReachedMax];
}

class PopularMoviesError extends PopularMoviesState {
  final String message;

  const PopularMoviesError({required this.message});

  @override
  List<Object> get props => [message];
} 