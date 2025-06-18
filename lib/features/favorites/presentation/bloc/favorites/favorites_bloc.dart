import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:muvo/features/favorites/domain/entities/favorite.dart';
import 'package:muvo/features/favorites/domain/repositories/favorites_repository.dart';
import 'package:muvo/features/movies/domain/entities/movie.dart';

part 'favorites_event.dart';
part 'favorites_state.dart';

class FavoritesBloc extends Bloc<FavoritesEvent, FavoritesState> {
  final FavoritesRepository favoritesRepository;

  FavoritesBloc({required this.favoritesRepository}) : super(FavoritesInitial()) {
    on<LoadFavorites>(_onLoadFavorites);
    on<AddToFavorites>(_onAddToFavorites);
    on<RemoveFromFavorites>(_onRemoveFromFavorites);
  }

  Future<void> _onLoadFavorites(
    LoadFavorites event,
    Emitter<FavoritesState> emit,
  ) async {
    emit(FavoritesLoading());
    try {
      await emit.forEach<List<dynamic>>(
        favoritesRepository.getFavorites(),
        onData: (favorites) {
          if (favorites == null) return FavoritesLoaded(favorites: []);
          return FavoritesLoaded(
            favorites: favorites.map((f) => f as Favorite).toList(),
          );
        },
        onError: (error, _) => FavoritesError(
          message: error.toString().contains('Usuario no autenticado')
              ? 'Por favor, inicia sesión para ver tus favoritos'
              : 'Error al cargar favoritos',
        ),
      );
    } catch (e) {
      emit(FavoritesError(
        message: e.toString().contains('Usuario no autenticado')
            ? 'Por favor, inicia sesión para ver tus favoritos'
            : 'Error al cargar favoritos',
      ));
    }
  }

  Future<void> _onAddToFavorites(
    AddToFavorites event,
    Emitter<FavoritesState> emit,
  ) async {
    try {
      await favoritesRepository.addToFavorites(event.movie);
    } catch (e) {
      emit(FavoritesError(message: e.toString()));
    }
  }

  Future<void> _onRemoveFromFavorites(
    RemoveFromFavorites event,
    Emitter<FavoritesState> emit,
  ) async {
    try {
      await favoritesRepository.removeFromFavorites(event.movie);
    } catch (e) {
      emit(FavoritesError(message: e.toString()));
    }
  }

  bool isFavorite(Movie movie) {
    if (state is FavoritesLoaded) {
      final favorites = (state as FavoritesLoaded).favorites;
      return favorites.any((f) => f.movie.id == movie.id);
    }
    return false;
  }
} 