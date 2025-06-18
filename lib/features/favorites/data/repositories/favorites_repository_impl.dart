import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:muvo/features/favorites/domain/entities/favorite.dart';
import 'package:muvo/features/favorites/domain/repositories/favorites_repository.dart';
import 'package:muvo/features/movies/domain/entities/movie.dart';

class FavoritesRepositoryImpl implements FavoritesRepository {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;
  static const String _collection = 'favorites';

  FavoritesRepositoryImpl({
    FirebaseFirestore? firestore,
    FirebaseAuth? auth,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _auth = auth ?? FirebaseAuth.instance;

  @override
  Stream<List<dynamic>> getFavorites() {
    final userId = _auth.currentUser?.uid;
    if (userId == null) {
      throw Exception('Usuario no autenticado. Por favor, inicia sesión para ver tus favoritos.');
    }

    return _firestore
        .collection(_collection)
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      if (snapshot.docs.isEmpty) return [];
      return snapshot.docs
          .map((doc) => Favorite.fromJson({...doc.data(), 'id': doc.id}))
          .toList();
    });
  }

  @override
  Future<void> addToFavorites(Movie movie) async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) throw Exception('Usuario no autenticado');

    final favorite = Favorite(
      id: '', // Firestore generará el ID
      userId: userId,
      movie: movie,
      createdAt: DateTime.now(),
    );

    await _firestore.collection(_collection).add(favorite.toJson());
  }

  @override
  Future<void> removeFromFavorites(Movie movie) async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) throw Exception('Usuario no autenticado');

    final querySnapshot = await _firestore
        .collection(_collection)
        .where('userId', isEqualTo: userId)
        .where('movie.id', isEqualTo: movie.id)
        .get();

    for (var doc in querySnapshot.docs) {
      await doc.reference.delete();
    }
  }

  @override
  Future<bool> isFavorite(Movie movie) async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) return false;

    final querySnapshot = await _firestore
        .collection(_collection)
        .where('userId', isEqualTo: userId)
        .where('movie.id', isEqualTo: movie.id)
        .get();

    return querySnapshot.docs.isNotEmpty;
  }
} 