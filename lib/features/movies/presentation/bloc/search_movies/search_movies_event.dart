part of 'search_movies_bloc.dart';

abstract class SearchMoviesEvent extends Equatable {
  const SearchMoviesEvent();

  @override
  List<Object> get props => [];
}

class SearchMoviesQueryChanged extends SearchMoviesEvent {
  final String query;

  const SearchMoviesQueryChanged(this.query);

  @override
  List<Object> get props => [query];
}

class SearchMoviesCleared extends SearchMoviesEvent {} 