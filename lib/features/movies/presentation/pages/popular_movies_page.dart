import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:muvo/features/movies/di/movies_module.dart';
import 'package:muvo/features/movies/presentation/bloc/popular_movies/popular_movies_bloc.dart';
import 'package:muvo/features/movies/presentation/widgets/movie_card.dart';

class PopularMoviesPage extends StatelessWidget {
  const PopularMoviesPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Disparar la carga de películas populares al montar la página
    context.read<PopularMoviesBloc>().add(LoadPopularMovies());
    
    return BlocBuilder<PopularMoviesBloc, PopularMoviesState>(
      builder: (context, state) {
        if (state is PopularMoviesLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is PopularMoviesError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(state.message),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    context.read<PopularMoviesBloc>().add(LoadPopularMovies());
                  },
                  child: const Text('Reintentar'),
                ),
              ],
            ),
          );
        }

        if (state is PopularMoviesLoaded) {
          if (state.movies.isEmpty) {
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
            itemCount: state.movies.length,
            itemBuilder: (context, index) {
              final movie = state.movies[index];
              return MovieCard(movie: movie);
            },
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
} 