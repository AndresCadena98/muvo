import 'package:equatable/equatable.dart';

class MovieVideo extends Equatable {
  final String id;
  final String key;
  final String name;
  final String site;
  final String type;
  final int size;

  const MovieVideo({
    required this.id,
    required this.key,
    required this.name,
    required this.site,
    required this.type,
    required this.size,
  });

  @override
  List<Object> get props => [
        id,
        key,
        name,
        site,
        type,
        size,
      ];
} 