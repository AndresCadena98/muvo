import 'package:equatable/equatable.dart';

class MovieCredit extends Equatable {
  final int id;
  final String name;
  final String? profilePath;
  final String character;
  final String department;
  final String job;

  const MovieCredit({
    required this.id,
    required this.name,
    this.profilePath,
    required this.character,
    required this.department,
    required this.job,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        profilePath,
        character,
        department,
        job,
      ];
} 