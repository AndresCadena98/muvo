part of 'popular_movies_bloc.dart';

abstract class PopularMoviesEvent extends Equatable {
  const PopularMoviesEvent();

  @override
  List<Object> get props => [];
}

class LoadPopularMovies extends PopularMoviesEvent {}

class LoadMorePopularMovies extends PopularMoviesEvent {}

class RefreshPopularMovies extends PopularMoviesEvent {} 