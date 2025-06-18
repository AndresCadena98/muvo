import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:muvo/features/movies/domain/entities/movie.dart';
import 'package:muvo/features/movies/presentation/bloc/movies/movies_bloc.dart';
import 'package:muvo/features/movies/presentation/pages/movie_details_page.dart';
import 'package:muvo/features/movies/di/movies_module.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:muvo/core/config/app_config.dart';
import 'package:muvo/features/explore/presentation/pages/explore_page.dart';
import 'package:muvo/features/favorites/presentation/pages/favorites_page.dart';
import 'package:muvo/features/settings/presentation/pages/settings_page.dart';
import 'package:muvo/features/favorites/presentation/bloc/favorites/favorites_bloc.dart';
import 'package:muvo/features/auth/presentation/bloc/auth/auth_bloc.dart';
import 'package:muvo/features/people/presentation/pages/people_page.dart';

class MoviesPage extends StatefulWidget {
  const MoviesPage({super.key});

  @override
  State<MoviesPage> createState() => _MoviesPageState();
}

class _MoviesPageState extends State<MoviesPage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const _HomeContent(),
    const ExplorePage(),
    const PeoplePage(),
    const SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BlocProvider(
                create: (context) => GetIt.I<FavoritesBloc>(),
                child: const FavoritesPage(),
              ),
            ),
          );
        },
        backgroundColor: AppConfig.accentColor,
        child: const Icon(Icons.favorite_rounded),
      ),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  Widget _buildBottomNavBar() {
    return Container(
      decoration: BoxDecoration(
        color: AppConfig.darkSurfaceColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        boxShadow: [
          BoxShadow(
            color: AppConfig.black.withOpacity(0.15),
            blurRadius: 15,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(Icons.home_rounded, 'Home', 0),
              _buildNavItem(Icons.explore_rounded, 'Explore', 1),
              _buildNavItem(Icons.people_rounded, 'Personas', 2),
              _buildNavItem(Icons.settings_rounded, 'Ajustes', 3),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    final isSelected = _currentIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _currentIndex = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppConfig.darkCardColor.withOpacity(0.2) : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          border: isSelected ? Border.all(
            color: AppConfig.darkTextPrimaryColor.withOpacity(0.1),
            width: 1,
          ) : null,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedScale(
              duration: const Duration(milliseconds: 200),
              scale: isSelected ? 1.2 : 1.0,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: isSelected ? AppConfig.darkCardColor.withOpacity(0.3) : Colors.transparent,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: isSelected ? AppConfig.darkTextPrimaryColor : AppConfig.darkTextSecondaryColor,
                  size: 22,
                ),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? AppConfig.darkTextPrimaryColor : AppConfig.darkTextSecondaryColor,
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HomeContent extends StatelessWidget {
  const _HomeContent();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocBuilder<MoviesBloc, MoviesState>(
        builder: (context, state) {
          if (state is MoviesLoading) {
            return const Center(child: CircularProgressIndicator(color: Colors.white));
          } else if (state is MoviesError) {
            return Center(
              child: Text(
                state.message,
                style: const TextStyle(color: Colors.redAccent),
              ),
            );
          } else if (state is MoviesLoaded && state.popularMovies.isNotEmpty) {
            final movies = state.popularMovies;
            return Stack(
              children: [
                // Fondo degradado superior
                Container(
                  height: 80,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        AppConfig.darkCardColor.withOpacity(0.3),
                        AppConfig.darkBackgroundColor,
                      ],
                    ),
                  ),
                ),
                // Contenido principal
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
               
                    // Swiper vertical de tarjetas
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Center(
                          child: Swiper(
                            itemCount: movies.length,
                            itemBuilder: (context, i) {
                              final movie = movies[i];
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => MovieDetailsPage(movie: movie, heroTagPrefix: 'stacked'),
                                    ),
                                  );
                                },
                                child: _MovieStackedCard(
                                  movie: movie,
                                  isFront: true,
                                  showOverview: true,
                                  showYear: true,
                                  showFavorite: true,
                                ),
                              );
                            },
                            scrollDirection: Axis.vertical,
                            viewportFraction: 0.85,
                            scale: 0.92,
                            loop: false,
                            itemHeight: 420,
                            itemWidth: 320,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            );
          } else {
            return const SizedBox.shrink();
          }
        },
      ),
    );
  }
}

class _MovieStackedCard extends StatelessWidget {
  final Movie movie;
  final bool isFront;
  final bool showOverview;
  final bool showYear;
  final bool showFavorite;
  const _MovieStackedCard({
    required this.movie,
    required this.isFront,
    this.showOverview = false,
    this.showYear = false,
    this.showFavorite = false,
  });

  @override
  Widget build(BuildContext context) {
    String? year;
    if (showYear && movie.releaseDate != null && movie.releaseDate!.isNotEmpty) {
      year = movie.releaseDate!.split('-').first;
    }
    return Container(
      width: 320,
      height: 420,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppConfig.darkSurfaceColor,
            AppConfig.darkSurfaceColor.withOpacity(0.95),
            AppConfig.darkSurfaceColor.withOpacity(0.9),
          ],
          stops: const [0.0, 0.7, 1.0],
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: Stack(
          children: [
            // Imagen de portada
            Positioned.fill(
              child: Image.network(
                movie.posterUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: AppConfig.darkBackgroundColor,
                  child: Icon(Icons.broken_image, color: AppConfig.darkTextSecondaryColor, size: 60),
                ),
              ),
            ),
            // Degradado inferior
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              height: showOverview ? 210 : 180,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      AppConfig.darkBackgroundColor.withOpacity(0.95),
                      AppConfig.darkBackgroundColor,
                    ],
                    stops: const [0.0, 0.5, 1.0],
                  ),
                ),
              ),
            ),
            // Info de la película
            Positioned(
              left: 0,
              right: 0,
              bottom: 32,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            movie.title,
                            style: AppConfig.headingStyle.copyWith(
                              fontSize: 26,
                              color: AppConfig.darkTextPrimaryColor,
                            ),
                          ),
                        ),
                        if (showFavorite)
                          BlocBuilder<FavoritesBloc, FavoritesState>(
                            builder: (context, state) {
                              final isFavorite = state is FavoritesLoaded && 
                                  context.read<FavoritesBloc>().isFavorite(movie);
                              return IconButton(
                                icon: Icon(
                                  isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                                  color: isFavorite ? AppConfig.accentColor : AppConfig.darkTextPrimaryColor,
                                  size: 26,
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
                      ],
                    ),
                    if (year != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        year,
                        style: AppConfig.bodyStyle.copyWith(
                          color: AppConfig.darkTextSecondaryColor,
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Icon(Icons.star_rounded, color: AppConfig.darkTextPrimaryColor, size: 22),
                        const SizedBox(width: 4),
                        Text(
                          movie.voteAverage != null ? '${movie.voteAverage.toStringAsFixed(1)}/10' : '-',
                          style: AppConfig.bodyStyle.copyWith(
                            color: AppConfig.darkTextPrimaryColor,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    if (showOverview && movie.overview.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      Text(
                        movie.overview.length > 120
                            ? movie.overview.substring(0, 120) + '...'
                            : movie.overview,
                        style: AppConfig.bodyStyle.copyWith(
                          color: AppConfig.darkTextSecondaryColor,
                          fontSize: 14,
                          height: 1.3,
                        ),
                        maxLines: 4,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
} 