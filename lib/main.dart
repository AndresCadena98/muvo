import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muvo/core/config/app_config.dart';
import 'package:muvo/core/config/env_config.dart';
import 'package:muvo/features/movies/domain/usecases/get_popular_movies.dart';
import 'package:muvo/features/movies/presentation/bloc/movies_bloc.dart';
import 'package:muvo/features/movies/presentation/pages/movies_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EnvConfig.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConfig.appName,
      theme: ThemeData(
        colorScheme: const ColorScheme.dark(
          primary: AppConfig.primaryColor,
          secondary: AppConfig.accentColor,
          background: AppConfig.backgroundColor,
          surface: AppConfig.surfaceColor,
        ),
        scaffoldBackgroundColor: AppConfig.backgroundColor,
        appBarTheme: const AppBarTheme(
          backgroundColor: AppConfig.primaryColor,
          elevation: 0,
        ),
        cardTheme: CardTheme(
          color: AppConfig.surfaceColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      home: BlocProvider(
        create: (context) => MoviesBloc(
          getPopularMovies: GetPopularMovies(
            // TODO: Implementar el repositorio
            throw UnimplementedError(),
          ),
        ),
        child: const MoviesPage(),
      ),
    );
  }
}
