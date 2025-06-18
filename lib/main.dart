import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:muvo/features/movies/di/movies_module.dart';
import 'package:muvo/features/favorites/di/favorites_module.dart';
import 'package:muvo/features/auth/di/auth_module.dart';
import 'package:muvo/features/settings/di/settings_module.dart';
import 'package:muvo/features/auth/presentation/pages/login_page.dart';
import 'package:muvo/features/movies/presentation/pages/movies_page.dart';
import 'package:muvo/features/movies/presentation/pages/splash_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muvo/features/auth/presentation/bloc/auth/auth_bloc.dart';
import 'package:muvo/features/settings/presentation/cubit/settings_cubit.dart';
import 'package:get_it/get_it.dart';
import 'package:muvo/core/services/language_service.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:muvo/core/l10n/app_localizations.dart';
import 'package:muvo/features/movies/presentation/bloc/movies/movies_bloc.dart';
import 'package:muvo/features/favorites/presentation/bloc/favorites/favorites_bloc.dart';
import 'package:muvo/features/movies/presentation/bloc/movie_details/movie_details_bloc.dart';
import 'package:muvo/features/movies/presentation/bloc/search_movies/search_movies_bloc.dart';
import 'package:muvo/features/movies/presentation/bloc/popular_movies/popular_movies_bloc.dart';
import 'package:muvo/core/theme/app_theme.dart';
import 'package:muvo/features/people/di/people_module.dart';
import 'package:muvo/features/people/presentation/bloc/people/people_bloc.dart';
import 'package:muvo/core/widgets/app_wrapper.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  
  // Inicializar Firebase con opciones específicas para cada plataforma
  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }
  
  // Configurar la localización de Firebase
  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: true,
    cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
  );
  
  final languageService = await LanguageService.create();
  GetIt.I.registerSingleton<LanguageService>(languageService);
  
  setupAuthModule();
  setupMoviesModule();
  setupFavoritesModule();
  setupSettingsModule();
  setupPeopleModule();
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: languageService),
        // Auth
        BlocProvider(create: (context) => GetIt.I<AuthBloc>()..add(AuthCheckRequested())),
        // Settings
        BlocProvider(create: (context) => GetIt.I<SettingsCubit>()),
        // Movies
        BlocProvider(create: (context) => GetIt.I<MoviesBloc>()..add(LoadMovies())),
        BlocProvider(create: (context) => GetIt.I<MovieDetailsBloc>()),
        BlocProvider(create: (context) => GetIt.I<SearchMoviesBloc>()),
        BlocProvider(create: (context) => GetIt.I<PopularMoviesBloc>()),
        // Favorites
        BlocProvider(create: (context) => GetIt.I<FavoritesBloc>()..add(LoadFavorites())),
        // People
        BlocProvider(create: (context) => GetIt.I<PeopleBloc>()..add(LoadPeople())),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Muvo',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.dark,
      localizationsDelegates: [
        const AppLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'),
        Locale('es'),
      ],
      builder: (context, child) {
        return AppWrapper(child: child!);
      },
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashPage(),
        '/login': (context) => const LoginPage(),
        '/movies': (context) => const MoviesPage(),
      },
    );
  }
}
