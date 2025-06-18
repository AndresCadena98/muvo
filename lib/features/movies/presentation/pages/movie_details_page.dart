import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:muvo/features/movies/domain/entities/movie.dart';
import 'package:muvo/features/movies/domain/entities/movie_credit.dart' as credit_entity;
import 'package:muvo/features/movies/domain/entities/movie_video.dart' as video_entity;
import 'package:muvo/features/movies/presentation/bloc/movie_details/movie_details_bloc.dart';
import 'package:muvo/features/movies/presentation/widgets/movie_card.dart';
import 'package:muvo/features/movies/di/movies_module.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:muvo/core/config/app_config.dart';
import 'package:muvo/features/favorites/presentation/bloc/favorites/favorites_bloc.dart';
import 'package:muvo/features/movies/presentation/pages/video_player_page.dart';
import 'package:muvo/features/movies/domain/entities/movie_video.dart';

final _getIt = GetIt.instance;

class MovieDetailsPage extends StatelessWidget {
  final Movie movie;
  final String heroTagPrefix;

  const MovieDetailsPage({
    super.key,
    required this.movie,
    this.heroTagPrefix = '',
  });

  String get _movieHeroTag => '${heroTagPrefix}_movie_${movie.id}';
  String get _titleHeroTag => '${heroTagPrefix}_title_${movie.id}';
  String _getCreditHeroTag(int creditId) => '${heroTagPrefix}_credit_$creditId';

  @override
  Widget build(BuildContext context) {
    // Disparar la carga de detalles al montar la página
    context.read<MovieDetailsBloc>().add(LoadMovieDetails(movie.id));
    
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: BlocBuilder<MovieDetailsBloc, MovieDetailsState>(
        builder: (context, state) {
          if (state is MovieDetailsLoading) {
            return const Center(
              child: CircularProgressIndicator(
                color: AppConfig.accentColor,
              ),
            );
          }

          if (state is MovieDetailsError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline_rounded,
                    size: 48,
                    color: Colors.red,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    state.message,
                    style: AppConfig.bodyStyle,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () {
                      context.read<MovieDetailsBloc>().add(
                            LoadMovieDetails(movie.id),
                          );
                    },
                    icon: const Icon(Icons.refresh_rounded),
                    label: const Text('Reintentar'),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: AppConfig.textPrimaryColor,
                    ),
                  ),
                ],
              ),
            );
          }

          if (state is MovieDetailsLoaded) {
            MovieVideo? trailer;
            if (state.videos.isNotEmpty) {
              try {
                trailer = state.videos.firstWhere((video) => video.type == 'Trailer');
              } catch (e) {
                trailer = state.videos.first;
              }
            }

            return Stack(
              children: [
                CustomScrollView(
                  physics: const BouncingScrollPhysics(),
                  slivers: [
                    _buildAppBar(context),
                    SliverToBoxAdapter(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildMovieInfo(context, state),
                          _buildCredits(context, state),
                          _buildVideos(context, state),
                          _buildReviews(context, state),
                          _buildSimilarMovies(context, state),
                          _buildRecommendations(context, state),
                          const SizedBox(height: 32),
                        ],
                      ),
                    ),
                  ],
                ),
                if (trailer != null)
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            AppConfig.backgroundColor.withOpacity(0.9),
                          ],
                        ),
                      ),
                      child: FloatingActionButton.extended(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => VideoPlayerPage(
                                videoId: trailer!.key,
                                videoTitle: trailer!.name,
                              ),
                            ),
                          );
                        },
                        icon: const Icon(Icons.play_arrow_rounded),
                        label: const Text('Ver Trailer'),
                        backgroundColor: AppConfig.primaryColor,
                        foregroundColor: AppConfig.textPrimaryColor,
                      ),
                    ),
                  ),
              ],
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: MediaQuery.of(context).size.height * 0.5,
      pinned: true,
      stretch: true,
      backgroundColor: AppConfig.backgroundColor,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppConfig.textPrimaryColor),
        onPressed: () => Navigator.pop(context),
      ),
      actions: [
        BlocBuilder<FavoritesBloc, FavoritesState>(
          builder: (context, state) {
            final isFavorite = state is FavoritesLoaded && 
                context.read<FavoritesBloc>().isFavorite(movie);
            return IconButton(
              icon: Icon(
                isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                color: isFavorite ? AppConfig.accentColor : AppConfig.textPrimaryColor,
              ),
              onPressed: () {
                if (isFavorite) {
                  context.read<FavoritesBloc>().add(RemoveFromFavorites(movie));
                } else {
                  context.read<FavoritesBloc>().add(AddToFavorites(movie));
                }
              },
            );
          },
        ),
        IconButton(
          icon: const Icon(Icons.share_rounded, color: AppConfig.textPrimaryColor),
          onPressed: () {
            // TODO: Implementar compartir
          },
        ),
        IconButton(
          icon: const Icon(Icons.more_vert_rounded, color: AppConfig.textPrimaryColor),
          onPressed: () {
            // TODO: Implementar menú de opciones
          },
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        stretchModes: const [
          StretchMode.zoomBackground,
          StretchMode.blurBackground,
        ],
        background: Stack(
          fit: StackFit.expand,
          children: [
            Hero(
              tag: _movieHeroTag,
              child: CachedNetworkImage(
                imageUrl: movie.backdropPath != null
                    ? 'https://image.tmdb.org/t/p/original${movie.backdropPath}'
                    : 'https://via.placeholder.com/500x750',
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  color: AppConfig.surfaceColor,
                  child: const Center(
                    child: CircularProgressIndicator(
                      color: AppConfig.accentColor,
                    ),
                  ),
                ),
                errorWidget: (context, url, error) => Container(
                  color: AppConfig.surfaceColor,
                  child: const Icon(
                    Icons.movie_rounded,
                    size: 100,
                    color: AppConfig.textSecondaryColor,
                  ),
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    AppConfig.backgroundColor.withOpacity(0.9),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMovieInfo(BuildContext context, MovieDetailsLoaded state) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Hero(
            tag: _titleHeroTag,
            child: Material(
              color: Colors.transparent,
              child: Text(
                movie.title,
                style: AppConfig.headingStyle,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppConfig.primaryColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.star_rounded,
                      color: AppConfig.accentColor,
                      size: 20,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      movie.voteAverage.toStringAsFixed(1),
                      style: const TextStyle(
                        color: AppConfig.textPrimaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              if (movie.releaseDate != null)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppConfig.surfaceColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    movie.releaseDate!.split('-')[0],
                    style: const TextStyle(
                      color: AppConfig.textPrimaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 24),
          Text(
            'Sinopsis',
            style: AppConfig.headingStyle.copyWith(fontSize: 20),
          ),
          const SizedBox(height: 12),
          Text(
            movie.overview,
            style: AppConfig.bodyStyle.copyWith(height: 1.5),
          ),
        ],
      ),
    );
  }

  Widget _buildCredits(BuildContext context, MovieDetailsLoaded state) {
    if (state.credits.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            'Reparto',
            style: AppConfig.headingStyle.copyWith(fontSize: 20),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 220,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            itemCount: state.credits.length,
            itemBuilder: (context, index) {
              final credit = state.credits[index];
              return SizedBox(
                width: 140,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Hero(
                      tag: _getCreditHeroTag(credit.id),
                      child: Container(
                        height: 160,
                        width: 140,
                        margin: const EdgeInsets.only(right: 16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 12,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(24),
                          child: CachedNetworkImage(
                            imageUrl: credit.profilePath != null
                                ? 'https://image.tmdb.org/t/p/w200${credit.profilePath}'
                                : 'https://via.placeholder.com/200x300',
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Container(
                              color: AppConfig.surfaceColor,
                              child: const Center(
                                child: CircularProgressIndicator(
                                  color: AppConfig.accentColor,
                                ),
                              ),
                            ),
                            errorWidget: (context, url, error) => Container(
                              color: AppConfig.surfaceColor,
                              child: const Icon(
                                Icons.person_rounded,
                                size: 50,
                                color: AppConfig.textSecondaryColor,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      credit.name,
                      style: AppConfig.bodyStyle.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppConfig.textPrimaryColor,
                        fontSize: 12,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      credit.character,
                      style: AppConfig.bodyStyle.copyWith(
                        color: AppConfig.textSecondaryColor,
                        fontSize: 11,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildVideos(BuildContext context, MovieDetailsLoaded state) {
    if (state.videos.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            'Videos',
            style: AppConfig.headingStyle.copyWith(fontSize: 20),
          ),
        ),
        SizedBox(
          height: 220,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            itemCount: state.videos.length,
            itemBuilder: (context, index) {
              final video = state.videos[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => VideoPlayerPage(
                        videoId: video.key,
                        videoTitle: video.name,
                      ),
                    ),
                  );
                },
                child: Container(
                  width: 320,
                  margin: const EdgeInsets.only(right: 16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 12,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: Stack(
                      children: [
                        CachedNetworkImage(
                          imageUrl: 'https://img.youtube.com/vi/${video.key}/maxresdefault.jpg',
                          height: 220,
                          width: 320,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Container(
                            color: AppConfig.surfaceColor,
                            child: const Center(
                              child: CircularProgressIndicator(
                                color: AppConfig.accentColor,
                              ),
                            ),
                          ),
                          errorWidget: (context, url, error) => Container(
                            color: AppConfig.surfaceColor,
                            child: const Icon(
                              Icons.play_circle_outline_rounded,
                              size: 50,
                              color: AppConfig.textSecondaryColor,
                            ),
                          ),
                        ),
                        Center(
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppConfig.primaryColor.withOpacity(0.8),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.play_arrow_rounded,
                              color: AppConfig.textPrimaryColor,
                              size: 40,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildReviews(BuildContext context, MovieDetailsLoaded state) {
    if (state.reviews.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            'Reseñas',
            style: AppConfig.headingStyle.copyWith(fontSize: 20),
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 24),
          itemCount: state.reviews.length,
          itemBuilder: (context, index) {
            final review = state.reviews[index];
            return Container(
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: AppConfig.surfaceColor,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 12,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: AppConfig.primaryColor,
                          child: Text(
                            review.author.isNotEmpty ? review.author[0].toUpperCase() : '?',
                            style: const TextStyle(
                              color: AppConfig.textPrimaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                review.author,
                                style: AppConfig.bodyStyle.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: AppConfig.textPrimaryColor,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.star_rounded,
                                    color: AppConfig.accentColor,
                                    size: 16,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    review.rating.toStringAsFixed(1),
                                    style: AppConfig.bodyStyle.copyWith(
                                      color: AppConfig.textSecondaryColor,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      review.content,
                      style: AppConfig.bodyStyle.copyWith(height: 1.5),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildSimilarMovies(BuildContext context, MovieDetailsLoaded state) {
    if (state.similarMovies.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            'Películas Similares',
            style: AppConfig.headingStyle.copyWith(fontSize: 20),
          ),
        ),
        SizedBox(
          height: 320,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            itemCount: state.similarMovies.length,
            itemBuilder: (context, index) {
              final movie = state.similarMovies[index];
              return Container(
                width: 180,
                margin: const EdgeInsets.only(right: 16),
                child: MovieCard(
                  movie: movie,
                  heroTagPrefix: 'similar_movies_${movie.id}',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MovieDetailsPage(
                          movie: movie,
                          heroTagPrefix: 'similar_movies_${movie.id}',
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildRecommendations(BuildContext context, MovieDetailsLoaded state) {
    if (state.recommendations.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            'Recomendaciones',
            style: AppConfig.headingStyle.copyWith(fontSize: 20),
          ),
        ),
        SizedBox(
          height: 320,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            itemCount: state.recommendations.length,
            itemBuilder: (context, index) {
              final movie = state.recommendations[index];
              return Container(
                width: 180,
                margin: const EdgeInsets.only(right: 16),
                child: MovieCard(
                  movie: movie,
                  heroTagPrefix: 'recommendations_${movie.id}',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MovieDetailsPage(
                          movie: movie,
                          heroTagPrefix: 'recommendations_${movie.id}',
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }
} 