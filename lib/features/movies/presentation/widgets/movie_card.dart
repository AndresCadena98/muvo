import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:muvo/core/config/app_config.dart';
import 'package:muvo/features/movies/domain/entities/movie.dart';

class MovieCard extends StatelessWidget {
  final Movie movie;

  const MovieCard({
    super.key,
    required this.movie,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppConfig.surfaceColor,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: CachedNetworkImage(
              imageUrl: 'https://image.tmdb.org/t/p/w500${movie.posterPath}',
              fit: BoxFit.cover,
              width: double.infinity,
              placeholder: (context, url) => const Center(
                child: CircularProgressIndicator(),
              ),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  movie.title,
                  style: AppConfig.bodyStyle.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(
                      Icons.star,
                      color: Colors.amber,
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      movie.voteAverage.toStringAsFixed(1),
                      style: AppConfig.bodyStyle,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
} 