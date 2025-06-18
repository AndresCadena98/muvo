import 'package:flutter/material.dart';
import 'package:muvo/features/movies/domain/entities/movie.dart';
import 'package:muvo/features/movies/presentation/widgets/movie_card.dart';
import 'package:muvo/core/config/app_config.dart';

class PaginatedGridView extends StatefulWidget {
  final List<Movie> movies;
  final bool isLoading;
  final bool hasError;
  final String? errorMessage;
  final VoidCallback onLoadMore;
  final VoidCallback onRetry;
  final bool hasReachedMax;

  const PaginatedGridView({
    super.key,
    required this.movies,
    required this.isLoading,
    required this.hasError,
    this.errorMessage,
    required this.onLoadMore,
    required this.onRetry,
    required this.hasReachedMax,
  });

  @override
  State<PaginatedGridView> createState() => _PaginatedGridViewState();
}

class _PaginatedGridViewState extends State<PaginatedGridView> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      widget.onLoadMore();
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.hasError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              color: Colors.red,
              size: 48,
            ),
            const SizedBox(height: 16),
            Text(
              widget.errorMessage ?? 'Ha ocurrido un error',
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: widget.onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Reintentar'),
            ),
          ],
        ),
      );
    }

    if (widget.movies.isEmpty && !widget.isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.movie_outlined,
              size: 48,
              color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'No se encontraron películas',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
      );
    }

    return Stack(
      children: [
        GridView.builder(
          controller: _scrollController,
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.7,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: widget.movies.length + (widget.hasReachedMax ? 0 : 1),
          itemBuilder: (context, index) {
            if (index >= widget.movies.length) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            final movie = widget.movies[index];
            return AnimatedBuilder(
              animation: _scrollController,
              builder: (context, child) {
                final itemPosition = index * 200.0;
                final scrollPosition = _scrollController.position.pixels;
                final opacity = (1.0 - (scrollPosition - itemPosition).abs() / 1000).clamp(0.0, 1.0);
                final scale = (1.0 - (scrollPosition - itemPosition).abs() / 2000).clamp(0.8, 1.0);

                return Transform.scale(
                  scale: scale,
                  child: Opacity(
                    opacity: opacity,
                    child: child,
                  ),
                );
              },
              child: MovieCard(movie: movie),
            );
          },
        ),
        if (widget.isLoading && widget.movies.isNotEmpty)
          Positioned(
            bottom: 16,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: AppConfig.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const CircularProgressIndicator(),
              ),
            ),
          ),
      ],
    );
  }
} 