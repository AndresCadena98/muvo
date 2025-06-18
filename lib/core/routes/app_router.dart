import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muvo/features/movies/presentation/pages/splash_page.dart';
import 'package:muvo/features/movies/presentation/pages/movies_page.dart';
import 'package:muvo/features/movies/presentation/pages/popular_movies_page.dart';
import 'package:muvo/features/movies/presentation/pages/search_movies_page.dart';
import 'package:muvo/features/movies/presentation/bloc/movies_bloc.dart';
import 'package:muvo/features/movies/presentation/bloc/popular_movies/popular_movies_bloc.dart';
import 'package:muvo/features/movies/presentation/bloc/search_movies/search_movies_bloc.dart';
import 'package:muvo/features/people/presentation/pages/people_page.dart';
import 'package:muvo/features/people/presentation/bloc/people/people_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:muvo/core/di/injection_container.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: const SplashPage(),
        transitionsBuilder: _globalTransition,
      ),
    ),
    GoRoute(
      path: '/home',
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: BlocProvider(
          create: (context) => getIt<MoviesBloc>(),
          child: const MoviesPage(),
        ),
        transitionsBuilder: _globalTransition,
      ),
    ),
    GoRoute(
      path: '/movies/popular',
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: BlocProvider(
          create: (context) => getIt<PopularMoviesBloc>(),
          child: const PopularMoviesPage(),
        ),
        transitionsBuilder: _globalTransition,
      ),
    ),
    GoRoute(
      path: '/movies/search',
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: BlocProvider(
          create: (context) => getIt<SearchMoviesBloc>(),
          child: const SearchMoviesPage(),
        ),
        transitionsBuilder: _globalTransition,
      ),
    ),
    GoRoute(
      path: '/people',
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: BlocProvider(
          create: (context) => getIt<PeopleBloc>(),
          child: const PeoplePage(),
        ),
        transitionsBuilder: _globalTransition,
      ),
    ),
  ],
);

Widget _globalTransition(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
  return FadeTransition(
    opacity: animation,
    child: ScaleTransition(
      scale: Tween<double>(begin: 0.98, end: 1.0).animate(
        CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
      ),
      child: child,
    ),
  );
} 