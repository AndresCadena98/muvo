import 'package:muvo/features/people/data/datasources/person_remote_data_source.dart';
import 'package:muvo/features/people/domain/entities/person.dart';
import 'package:muvo/features/people/domain/repositories/person_repository.dart';

class PersonRepositoryImpl implements PersonRepository {
  final PersonRemoteDataSource remoteDataSource;

  PersonRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<Person>> getPopularPeople({int page = 1}) async {
    return await remoteDataSource.getPopularPeople(page: page);
  }

  @override
  Future<Person> getPersonDetails(int id) async {
    return await remoteDataSource.getPersonDetails(id);
  }

  @override
  Future<List<Person>> searchPeople(String query, {int page = 1}) async {
    return await remoteDataSource.searchPeople(query, page: page);
  }

  @override
  Future<List<Person>> getPersonMovieCredits(int personId) async {
    return await remoteDataSource.getPersonMovieCredits(personId);
  }

  @override
  Future<List<Person>> getPersonTvCredits(int personId) async {
    return await remoteDataSource.getPersonTvCredits(personId);
  }

  @override
  Future<List<Person>> getPersonCombinedCredits(int personId) async {
    return await remoteDataSource.getPersonCombinedCredits(personId);
  }

  @override
  Future<List<Person>> getPersonImages(int personId) async {
    return await remoteDataSource.getPersonImages(personId);
  }

  @override
  Future<List<Person>> getPersonTaggedImages(int personId) async {
    return await remoteDataSource.getPersonTaggedImages(personId);
  }

  @override
  Future<List<Person>> getPersonChanges(int personId) async {
    return await remoteDataSource.getPersonChanges(personId);
  }
} 