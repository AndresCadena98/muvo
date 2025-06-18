import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muvo/core/config/app_config.dart';
import 'package:muvo/core/di/injection_container.dart';
import 'package:muvo/features/movies/domain/entities/movie.dart';
import 'package:muvo/features/movies/presentation/bloc/movies/movies_bloc.dart';
import 'package:muvo/features/movies/di/movies_module.dart';
import 'package:muvo/features/movies/presentation/pages/movie_details_page.dart';
import 'dart:async';

class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  late final MoviesBloc _moviesBloc;
  String _selectedCategory = 'Todas';
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;
  Timer? _debounce;
  int _currentPage = 1;
  final ScrollController _scrollController = ScrollController();

  final Map<String, int> _categoryToGenreId = {
    'Todas': 0,
    'Acción': 28,
    'Comedia': 35,
    'Drama': 18,
    'Ciencia Ficción': 878,
    'Romance': 10749,
  };

  @override
  void initState() {
    super.initState();
    _moviesBloc = getIt<MoviesBloc>();
    _moviesBloc.add(LoadMovies());
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _moviesBloc.close();
    _scrollController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      if (_isSearching && _searchController.text.isNotEmpty) {
        _currentPage++;
        _moviesBloc.add(SearchMovies(_searchController.text, page: _currentPage));
      }
    }
  }

  void _onCategorySelected(String category) {
    setState(() {
      _selectedCategory = category;
      _currentPage = 1;
    });
    if (category == 'Todas') {
      _moviesBloc.add(LoadMovies());
    } else {
      final genreId = _categoryToGenreId[category];
      if (genreId != null) {
        _moviesBloc.add(LoadMoviesByGenre(genreId));
      }
    }
  }

  void _onSearchSubmitted(String query) {
    if (query.isNotEmpty) {
      setState(() {
        _currentPage = 1;
      });
      _moviesBloc.add(SearchMovies(query, page: _currentPage));
    } else {
      _moviesBloc.add(LoadMovies());
    }
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (query.isNotEmpty) {
        setState(() {
          _currentPage = 1;
        });
        _moviesBloc.add(SearchMovies(query, page: _currentPage));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _moviesBloc,
      child: Scaffold(
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Explorar',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontSize: 28,
                              color: AppConfig.textPrimaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Descubre nuevas películas',
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: AppConfig.textSecondaryColor,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: AppConfig.cardColor.withOpacity(0.3),
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: Icon(
                          _isSearching ? Icons.close_rounded : Icons.search_rounded,
                          color: AppConfig.textPrimaryColor
                        ),
                        onPressed: () {
                          setState(() {
                            _isSearching = !_isSearching;
                            if (!_isSearching) {
                              _searchController.clear();
                              _currentPage = 1;
                              _moviesBloc.add(LoadMovies());
                            }
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
              // Barra de búsqueda
              if (_isSearching)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child: TextField(
                    controller: _searchController,
                    style: TextStyle(color: AppConfig.textPrimaryColor),
                    decoration: InputDecoration(
                      hintText: 'Buscar películas...',
                      hintStyle: TextStyle(color: AppConfig.textSecondaryColor),
                      prefixIcon: Icon(Icons.search_rounded, color: AppConfig.textSecondaryColor),
                      suffixIcon: IconButton(
                        icon: Icon(Icons.clear_rounded, color: AppConfig.textSecondaryColor),
                        onPressed: () {
                          _searchController.clear();
                          _currentPage = 1;
                          _moviesBloc.add(LoadMovies());
                        },
                      ),
                      filled: true,
                      fillColor: AppConfig.cardColor.withOpacity(0.3),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    onChanged: _onSearchChanged,
                    onSubmitted: _onSearchSubmitted,
                  ),
                ),
              // Categorías
              if (!_isSearching)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: SizedBox(
                    height: 40,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: _categoryToGenreId.keys.map((category) {
                        return _buildCategoryChip(
                          category,
                          category == _selectedCategory,
                          onTap: () => _onCategorySelected(category),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              const SizedBox(height: 24),
              // Contenido principal
              Expanded(
                child: BlocBuilder<MoviesBloc, MoviesState>(
                  builder: (context, state) {
                    if (state is MoviesLoading && _currentPage == 1) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is MoviesLoaded) {
                      return ListView(
                        controller: _scrollController,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        children: [
                          if (!_isSearching) ...[
                            _buildSection('Tendencias', _buildMovieGrid(state.popularMovies), context),
                            const SizedBox(height: 32),
                            _buildSection('Recomendadas', _buildMovieGrid(state.topRatedMovies), context),
                            const SizedBox(height: 32),
                            _buildSection('Próximamente', _buildMovieGrid(state.upcomingMovies), context),
                          ] else ...[
                            if (state.searchResults.isEmpty)
                              Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(32.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.search_off_rounded,
                                        size: 64,
                                        color: AppConfig.textSecondaryColor,
                                      ),
                                      const SizedBox(height: 16),
                                      Text(
                                        'No se encontraron resultados',
                                        style: TextStyle(
                                          color: AppConfig.textSecondaryColor,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            else
                              _buildSection('Resultados de búsqueda', _buildMovieGrid(state.searchResults), context),
                          ],
                          if (state is MoviesLoading && _currentPage > 1)
                            const Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Center(child: CircularProgressIndicator()),
                            ),
                        ],
                      );
                    } else if (state is MoviesError) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.error_outline_rounded,
                              size: 64,
                              color: AppConfig.textSecondaryColor,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Error: ${state.message}',
                              style: TextStyle(color: AppConfig.textSecondaryColor),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () {
                                if (_isSearching) {
                                  _moviesBloc.add(SearchMovies(_searchController.text, page: 1));
                                } else {
                                  _moviesBloc.add(LoadMovies());
                                }
                              },
                              child: const Text('Reintentar'),
                            ),
                          ],
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryChip(String label, bool isSelected, {required VoidCallback onTap}) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? AppConfig.cardColor : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isSelected ? AppConfig.textPrimaryColor : AppConfig.textSecondaryColor.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? AppConfig.textPrimaryColor : AppConfig.textSecondaryColor,
              fontSize: 14,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSection(String title, Widget content, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontSize: 20,
                color: AppConfig.textPrimaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton(
              onPressed: () {},
              child: Text(
                'Ver todo',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppConfig.primaryColor,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        content,
      ],
    );
  }

  Widget _buildMovieGrid(List<Movie> movies) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.7,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: movies.length,
      itemBuilder: (context, index) {
        final movie = movies[index];
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MovieDetailsPage(
                  movie: movie,
                  heroTagPrefix: 'explore',
                ),
              ),
            );
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: AppConfig.cardColor,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Stack(
                children: [
                  // Imagen de la película
                  if (movie.posterPath != null)
                    Image.network(
                      movie.posterUrl,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: AppConfig.surfaceColor,
                          child: Center(
                            child: Icon(
                              Icons.movie_rounded,
                              color: AppConfig.textSecondaryColor,
                              size: 40,
                            ),
                          ),
                        );
                      },
                    )
                  else
                    Container(
                      color: AppConfig.surfaceColor,
                      child: Center(
                        child: Icon(
                          Icons.movie_rounded,
                          color: AppConfig.textSecondaryColor,
                          size: 40,
                        ),
                      ),
                    ),
                  // Gradiente inferior
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    height: 80,
                    child: Container(
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
                  ),
                  // Título de la película
                  Positioned(
                    left: 12,
                    right: 12,
                    bottom: 12,
                    child: Text(
                      movie.title,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppConfig.textPrimaryColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
} 