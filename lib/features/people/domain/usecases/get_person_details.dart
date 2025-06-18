import 'package:muvo/features/people/domain/entities/person.dart';
import 'package:muvo/features/people/domain/repositories/person_repository.dart';

class GetPersonDetails {
  final PersonRepository repository;

  GetPersonDetails(this.repository);

  Future<Person> call(int personId) async {
    return await repository.getPersonDetails(personId);
  }
} 