import 'package:equatable/equatable.dart';

class Person extends Equatable {
  final int id;
  final String name;
  final String? profilePath;
  final String? knownForDepartment;
  final double popularity;
  final String? biography;
  final String? birthday;
  final String? deathday;
  final String? placeOfBirth;
  final int? gender;
  final String? imdbId;
  final String? homepage;

  const Person({
    required this.id,
    required this.name,
    this.profilePath,
    this.knownForDepartment,
    required this.popularity,
    this.biography,
    this.birthday,
    this.deathday,
    this.placeOfBirth,
    this.gender,
    this.imdbId,
    this.homepage,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        profilePath,
        knownForDepartment,
        popularity,
        biography,
        birthday,
        deathday,
        placeOfBirth,
        gender,
        imdbId,
        homepage,
      ];

  String get profileUrl => profilePath != null
      ? 'https://image.tmdb.org/t/p/w500$profilePath'
      : 'https://via.placeholder.com/500x750';
} 