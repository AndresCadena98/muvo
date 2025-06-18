import 'package:flutter/material.dart';
import 'package:muvo/features/movies/presentation/pages/popular_movies_page.dart';
import 'package:muvo/features/movies/presentation/pages/search_movies_page.dart';

class MoviesRoutes {
  static const String popularMovies = '/movies/popular';
  static const String searchMovies = '/movies/search';

  static Map<String, WidgetBuilder> getRoutes() {
    return {
      popularMovies: (context) => const PopularMoviesPage(),
      searchMovies: (context) => const SearchMoviesPage(),
    };
  }
} 