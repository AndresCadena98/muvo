import 'package:muvo/features/movies/domain/entities/movie_credit.dart';

class MovieCreditModel extends MovieCredit {
  const MovieCreditModel({
    required super.id,
    required super.name,
    required super.profilePath,
    required super.character,
    required super.department,
    required super.job,
  });

  factory MovieCreditModel.fromJson(Map<String, dynamic> json) {
    return MovieCreditModel(
      id: json['id'] as int,
      name: json['name'] as String,
      profilePath: json['profile_path'] as String?,
      character: json['character'] as String? ?? '',
      department: json['department'] as String? ?? '',
      job: json['job'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'profile_path': profilePath,
      'character': character,
      'department': department,
      'job': job,
    };
  }
} 