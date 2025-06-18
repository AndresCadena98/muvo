import 'package:muvo/features/people/domain/entities/person.dart';

abstract class PersonRepository {
  Future<List<Person>> getPopularPeople({int page = 1});
  Future<Person> getPersonDetails(int id);
  Future<List<Person>> searchPeople(String query, {int page = 1});
  Future<List<Person>> getPersonMovieCredits(int personId);
  Future<List<Person>> getPersonTvCredits(int personId);
  Future<List<Person>> getPersonCombinedCredits(int personId);
  Future<List<Person>> getPersonImages(int personId);
  Future<List<Person>> getPersonTaggedImages(int personId);
  Future<List<Person>> getPersonChanges(int personId);
} 