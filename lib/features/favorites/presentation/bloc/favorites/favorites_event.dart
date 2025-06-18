part of 'favorites_bloc.dart';

abstract class FavoritesEvent extends Equatable {
  const FavoritesEvent();

  @override
  List<Object?> get props => [];
}

class LoadFavorites extends FavoritesEvent {}

class AddToFavorites extends FavoritesEvent {
  final Movie movie;
  const AddToFavorites(this.movie);

  @override
  List<Object?> get props => [movie];
}

class RemoveFromFavorites extends FavoritesEvent {
  final Movie movie;
  const RemoveFromFavorites(this.movie);

  @override
  List<Object?> get props => [movie];
} 