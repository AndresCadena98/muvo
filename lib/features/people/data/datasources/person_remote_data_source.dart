import 'package:dio/dio.dart';
import 'package:muvo/core/config/app_config.dart';
import 'package:muvo/core/services/language_service.dart';
import 'package:muvo/features/people/domain/entities/person.dart';
import 'package:muvo/features/people/data/models/person_model.dart';

abstract class PersonRemoteDataSource {
  Future<List<Person>> getPopularPeople({int page = 1});
  Future<Person> getPersonDetails(int id);
  Future<List<Person>> searchPeople(String query, {int page = 1});
  Future<List<PersonModel>> getPersonMovieCredits(int personId);
  Future<List<PersonModel>> getPersonTvCredits(int personId);
  Future<List<PersonModel>> getPersonCombinedCredits(int personId);
  Future<List<PersonModel>> getPersonImages(int personId);
  Future<List<PersonModel>> getPersonTaggedImages(int personId);
  Future<List<PersonModel>> getPersonChanges(int personId);
  void updateLanguage(String languageCode);
}

class PersonRemoteDataSourceImpl implements PersonRemoteDataSource {
  final Dio dio;
  final LanguageService languageService;

  PersonRemoteDataSourceImpl({
    required this.dio,
    required this.languageService,
  });

  @override
  Future<List<Person>> getPopularPeople({int page = 1}) async {
    final response = await dio.get(
      '/person/popular',
      queryParameters: {
        'api_key': AppConfig.tmdbApiKey,
        'language': languageService.currentLanguageCode,
        'page': page,
      },
    );
    return (response.data['results'] as List)
        .map((json) => PersonModel.fromJson(json))
        .toList();
  }

  @override
  Future<Person> getPersonDetails(int id) async {
    final response = await dio.get(
      '/person/$id',
      queryParameters: {
        'api_key': AppConfig.tmdbApiKey,
        'language': languageService.currentLanguageCode,
      },
    );
    return PersonModel.fromJson(response.data);
  }

  @override
  Future<List<Person>> searchPeople(String query, {int page = 1}) async {
    final response = await dio.get(
      '/search/person',
      queryParameters: {
        'api_key': AppConfig.tmdbApiKey,
        'language': languageService.currentLanguageCode,
        'query': query,
        'page': page,
      },
    );
    return (response.data['results'] as List)
        .map((json) => PersonModel.fromJson(json))
        .toList();
  }

  @override
  Future<List<PersonModel>> getPersonMovieCredits(int personId) async {
    final response = await dio.get('/person/$personId/movie_credits');
    return (response.data['cast'] as List)
        .map((json) => PersonModel.fromJson(json))
        .toList();
  }

  @override
  Future<List<PersonModel>> getPersonTvCredits(int personId) async {
    final response = await dio.get('/person/$personId/tv_credits');
    return (response.data['cast'] as List)
        .map((json) => PersonModel.fromJson(json))
        .toList();
  }

  @override
  Future<List<PersonModel>> getPersonCombinedCredits(int personId) async {
    final response = await dio.get('/person/$personId/combined_credits');
    return (response.data['cast'] as List)
        .map((json) => PersonModel.fromJson(json))
        .toList();
  }

  @override
  Future<List<PersonModel>> getPersonImages(int personId) async {
    final response = await dio.get('/person/$personId/images');
    return (response.data['profiles'] as List)
        .map((json) => PersonModel.fromJson(json))
        .toList();
  }

  @override
  Future<List<PersonModel>> getPersonTaggedImages(int personId) async {
    final response = await dio.get('/person/$personId/tagged_images');
    return (response.data['results'] as List)
        .map((json) => PersonModel.fromJson(json))
        .toList();
  }

  @override
  Future<List<PersonModel>> getPersonChanges(int personId) async {
    final response = await dio.get('/person/$personId/changes');
    return (response.data['changes'] as List)
        .map((json) => PersonModel.fromJson(json))
        .toList();
  }

  @override
  void updateLanguage(String languageCode) {
    dio.options.queryParameters['language'] = languageCode;
  }
} 