import 'package:muvo/features/movies/domain/entities/movie_video.dart';

class MovieVideoModel extends MovieVideo {
  const MovieVideoModel({
    required super.id,
    required super.key,
    required super.name,
    required super.site,
    required super.type,
    required super.size,
  });

  factory MovieVideoModel.fromJson(Map<String, dynamic> json) {
    return MovieVideoModel(
      id: json['id'] as String,
      key: json['key'] as String,
      name: json['name'] as String,
      site: json['site'] as String,
      type: json['type'] as String,
      size: json['size'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'key': key,
      'name': name,
      'site': site,
      'type': type,
      'size': size,
    };
  }
} 