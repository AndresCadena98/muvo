import 'package:flutter/material.dart';
import 'package:muvo/features/movies/domain/entities/movie.dart';
import 'package:muvo/features/movies/presentation/widgets/movie_card.dart';

class TopRatedMoviesPage extends StatelessWidget {
  final List<Movie> movies;

  const TopRatedMoviesPage({
    super.key,
    required this.movies,
  });

  @override
  Widget build(BuildContext context) {
    if (movies.isEmpty) {
      return const Center(
        child: Text('No se encontraron películas'),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.7,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: movies.length,
      itemBuilder: (context, index) {
        final movie = movies[index];
        return MovieCard(movie: movie);
      },
    );
  }
} 