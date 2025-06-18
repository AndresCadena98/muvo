import 'package:muvo/features/people/domain/entities/person.dart';

class PersonModel extends Person {
  const PersonModel({
    required super.id,
    required super.name,
    required super.profilePath,
    required super.knownForDepartment,
    required super.popularity,
    super.biography,
    super.birthday,
    super.deathday,
    super.placeOfBirth,
    super.gender,
    super.imdbId,
    super.homepage,
  });

  factory PersonModel.fromJson(Map<String, dynamic> json) {
    return PersonModel(
      id: json['id'] as int,
      name: json['name'] as String,
      profilePath: json['profile_path'] as String?,
      knownForDepartment: json['known_for_department'] as String?,
      popularity: (json['popularity'] as num).toDouble(),
      biography: json['biography'] as String?,
      birthday: json['birthday'] as String?,
      deathday: json['deathday'] as String?,
      placeOfBirth: json['place_of_birth'] as String?,
      gender: json['gender'] as int?,
      imdbId: json['imdb_id'] as String?,
      homepage: json['homepage'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'profile_path': profilePath,
      'known_for_department': knownForDepartment,
      'popularity': popularity,
      'biography': biography,
      'birthday': birthday,
      'deathday': deathday,
      'place_of_birth': placeOfBirth,
      'gender': gender,
      'imdb_id': imdbId,
      'homepage': homepage,
    };
  }
} 