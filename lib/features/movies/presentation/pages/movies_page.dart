import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muvo/core/config/app_config.dart';
import 'package:muvo/features/movies/presentation/bloc/movies_bloc.dart';
import 'package:muvo/features/movies/presentation/bloc/movies_event.dart';
import 'package:muvo/features/movies/presentation/bloc/movies_state.dart';
import 'package:muvo/features/movies/presentation/widgets/movie_card.dart';

class MoviesPage extends StatelessWidget {
  const MoviesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConfig.backgroundColor,
      appBar: AppBar(
        title: Text(
          AppConfig.appName,
          style: AppConfig.headingStyle,
        ),
        backgroundColor: AppConfig.primaryColor,
      ),
      body: BlocBuilder<MoviesBloc, MoviesState>(
        builder: (context, state) {
          if (state is MoviesInitial) {
            context.read<MoviesBloc>().add(LoadPopularMovies());
            return const Center(child: CircularProgressIndicator());
          }

          if (state is MoviesLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is MoviesError) {
            return Center(
              child: Text(
                state.message,
                style: AppConfig.bodyStyle,
              ),
            );
          }

          if (state is MoviesLoaded) {
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
      ),
    );
  }
} 