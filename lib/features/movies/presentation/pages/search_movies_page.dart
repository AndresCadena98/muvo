import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:muvo/features/movies/presentation/bloc/search_movies/search_movies_bloc.dart';
import 'package:muvo/features/movies/presentation/widgets/movie_card.dart';
import 'package:muvo/features/movies/presentation/widgets/search_bar.dart';

final _getIt = GetIt.instance;

class SearchMoviesPage extends StatelessWidget {
  const SearchMoviesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buscar Películas'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: MovieSearchBar(
              onChanged: (query) {
                context.read<SearchMoviesBloc>().add(
                      SearchMoviesQueryChanged(query),
                    );
              },
              onClear: () {
                context.read<SearchMoviesBloc>().add(
                      SearchMoviesCleared(),
                    );
              },
            ),
          ),
        ),
      ),
      body: BlocBuilder<SearchMoviesBloc, SearchMoviesState>(
        builder: (context, state) {
          if (state is SearchMoviesInitial) {
            return const Center(
              child: Text('Ingresa un término de búsqueda'),
            );
          }

          if (state is SearchMoviesLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is SearchMoviesError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(state.message),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<SearchMoviesBloc>().add(
                            SearchMoviesQueryChanged(state.query),
                          );
                    },
                    child: const Text('Reintentar'),
                  ),
                ],
              ),
            );
          }

          if (state is SearchMoviesEmpty) {
            return Center(
              child: Text(
                'No se encontraron resultados para "${state.query}"',
              ),
            );
          }

          if (state is SearchMoviesLoaded) {
            return GridView.builder(
              padding: const EdgeInsets.all(8),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.7,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
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
      ),
    );
  }
} 