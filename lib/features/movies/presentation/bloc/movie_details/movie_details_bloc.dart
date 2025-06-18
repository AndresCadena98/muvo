import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:muvo/features/movies/domain/entities/movie.dart';
import 'package:muvo/features/movies/domain/entities/movie_review.dart';
import 'package:muvo/features/movies/domain/entities/movie_credit.dart';
import 'package:muvo/features/movies/domain/entities/movie_video.dart';
import 'package:muvo/features/movies/domain/repositories/movie_repository.dart';

part 'movie_details_event.dart';
part 'movie_details_state.dart';

class MovieDetailsBloc extends Bloc<MovieDetailsEvent, MovieDetailsState> {
  final MovieRepository movieRepository;

  MovieDetailsBloc({
    required this.movieRepository,
  }) : super(MovieDetailsInitial()) {
    on<LoadMovieDetails>(_onLoadMovieDetails);
  }

  Future<void> _onLoadMovieDetails(
    LoadMovieDetails event,
    Emitter<MovieDetailsState> emit,
  ) async {
    emit(MovieDetailsLoading());

    try {
      final movie = await movieRepository.getMovieDetails(event.movieId);
      final credits = await movieRepository.getMovieCredits(event.movieId);
      final videos = await movieRepository.getMovieVideos(event.movieId);
      final reviews = await movieRepository.getMovieReviews(event.movieId);
      final similarMovies = await movieRepository.getSimilarMovies(event.movieId);
      final recommendations = await movieRepository.getRecommendations(event.movieId);

      emit(MovieDetailsLoaded(
        movie: movie,
        credits: credits,
        videos: videos,
        reviews: reviews,
        similarMovies: similarMovies,
        recommendations: recommendations,
      ));
    } catch (e) {
      emit(MovieDetailsError(message: e.toString()));
    }
  }
} 