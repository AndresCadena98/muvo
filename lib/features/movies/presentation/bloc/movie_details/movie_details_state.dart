part of 'movie_details_bloc.dart';

abstract class MovieDetailsState extends Equatable {
  const MovieDetailsState();

  @override
  List<Object> get props => [];
}

class MovieDetailsInitial extends MovieDetailsState {}

class MovieDetailsLoading extends MovieDetailsState {}

class MovieDetailsLoaded extends MovieDetailsState {
  final Movie movie;
  final List<MovieCredit> credits;
  final List<MovieVideo> videos;
  final List<MovieReview> reviews;
  final List<Movie> similarMovies;
  final List<Movie> recommendations;

  const MovieDetailsLoaded({
    required this.movie,
    required this.credits,
    required this.videos,
    required this.reviews,
    required this.similarMovies,
    required this.recommendations,
  });

  @override
  List<Object> get props => [
        movie,
        credits,
        videos,
        reviews,
        similarMovies,
        recommendations,
      ];
}

class MovieDetailsError extends MovieDetailsState {
  final String message;

  const MovieDetailsError({required this.message});

  @override
  List<Object> get props => [message];
} 