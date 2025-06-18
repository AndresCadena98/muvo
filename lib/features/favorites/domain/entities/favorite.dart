import 'package:equatable/equatable.dart';
import 'package:muvo/features/movies/domain/entities/movie.dart';

class Favorite extends Equatable {
  final String id;
  final String userId;
  final Movie movie;
  final DateTime createdAt;

  const Favorite({
    required this.id,
    required this.userId,
    required this.movie,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, userId, movie, createdAt];

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'movie': {
        'id': movie.id,
        'title': movie.title,
        'overview': movie.overview,
        'posterPath': movie.posterPath,
        'backdropPath': movie.backdropPath,
        'releaseDate': movie.releaseDate,
        'voteAverage': movie.voteAverage,
        'genreIds': movie.genreIds,
      },
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Favorite.fromJson(Map<String, dynamic> json) {
    return Favorite(
      id: json['id'] as String,
      userId: json['userId'] as String,
      movie: Movie(
        id: json['movie']['id'] as int,
        title: json['movie']['title'] as String,
        overview: json['movie']['overview'] as String,
        posterPath: json['movie']['posterPath'] as String?,
        backdropPath: json['movie']['backdropPath'] as String?,
        releaseDate: json['movie']['releaseDate'] as String?,
        voteAverage: (json['movie']['voteAverage'] as num).toDouble(),
        genreIds: List<int>.from(json['movie']['genreIds'] as List),
      ),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }
} 