import 'package:muvo/features/movies/domain/entities/movie_review.dart';

class MovieReviewModel extends MovieReview {
  const MovieReviewModel({
    required super.id,
    required super.author,
    required super.content,
    required super.url,
    required super.rating,
  });

  factory MovieReviewModel.fromJson(Map<String, dynamic> json) {
    return MovieReviewModel(
      id: json['id'] as String,
      author: json['author'] as String,
      content: json['content'] as String,
      url: json['url'] as String,
      rating: (json['author_details']['rating'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'author': author,
      'content': content,
      'url': url,
      'author_details': {
        'rating': rating,
      },
    };
  }
} 