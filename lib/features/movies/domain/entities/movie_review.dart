import 'package:equatable/equatable.dart';

class MovieReview extends Equatable {
  final String id;
  final String author;
  final String content;
  final String url;
  final double rating;

  const MovieReview({
    required this.id,
    required this.author,
    required this.content,
    required this.url,
    required this.rating,
  });

  @override
  List<Object> get props => [
        id,
        author,
        content,
        url,
        rating,
      ];
} 