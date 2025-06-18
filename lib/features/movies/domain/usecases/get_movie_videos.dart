import 'package:muvo/features/movies/domain/entities/movie.dart';
import 'package:muvo/features/movies/domain/repositories/movie_repository.dart';
import 'package:muvo/features/movies/domain/entities/movie_video.dart';

class GetMovieVideos {
  final MovieRepository repository;

  GetMovieVideos(this.repository);

  Future<List<MovieVideo>> call(int movieId) async {
    return await repository.getMovieVideos(movieId);
  }
} 