part of 'movies_bloc.dart';

abstract class MoviesEvent extends Equatable {
  const MoviesEvent();

  @override
  List<Object> get props => [];
}

class LoadMovies extends MoviesEvent {}

class LoadMoviesByGenre extends MoviesEvent {
  final int genreId;

  const LoadMoviesByGenre(this.genreId);

  @override
  List<Object> get props => [genreId];
}

class SearchMovies extends MoviesEvent {
  final String query;
  final int page;

  const SearchMovies(this.query, {this.page = 1});

  @override
  List<Object> get props => [query, page];
} 