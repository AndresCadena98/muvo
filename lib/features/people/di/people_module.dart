import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:muvo/core/config/app_config.dart';
import 'package:muvo/core/services/language_service.dart';
import 'package:muvo/features/people/data/datasources/person_remote_data_source.dart';
import 'package:muvo/features/people/data/repositories/person_repository_impl.dart';
import 'package:muvo/features/people/domain/repositories/person_repository.dart';
import 'package:muvo/features/people/presentation/bloc/people/people_bloc.dart';

void setupPeopleModule() {
  final getIt = GetIt.instance;

  // Data sources
  getIt.registerLazySingleton<PersonRemoteDataSource>(
    () => PersonRemoteDataSourceImpl(
      dio: Dio(
        BaseOptions(
          baseUrl: 'https://api.themoviedb.org/3',
          queryParameters: {
            'api_key': AppConfig.tmdbApiKey,
            'language': getIt<LanguageService>().currentLanguageCode,
          },
        ),
      ),
      languageService: getIt<LanguageService>(),
    ),
  );

  // Repositories
  getIt.registerLazySingleton<PersonRepository>(
    () => PersonRepositoryImpl(
      remoteDataSource: getIt(),
    ),
  );

  // BLoCs
  getIt.registerFactory<PeopleBloc>(
    () => PeopleBloc(
      personRepository: getIt(),
    ),
  );
} 