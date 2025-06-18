import 'package:flutter/material.dart';
import 'package:muvo/features/people/domain/entities/person.dart';
import 'package:muvo/core/config/app_config.dart';
import 'package:cached_network_image/cached_network_image.dart';

class PersonCard extends StatelessWidget {
  final Person person;
  final VoidCallback? onTap;

  const PersonCard({
    super.key,
    required this.person,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
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
        child: Stack(
          children: [
            // Imagen de perfil
            ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: CachedNetworkImage(
                imageUrl: person.profileUrl,
                height: double.infinity,
                width: double.infinity,
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
            // Gradiente y nombre
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.vertical(
                    bottom: Radius.circular(24),
                  ),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.8),
                    ],
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      person.name,
                      style: AppConfig.bodyStyle.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (person.knownForDepartment?.isNotEmpty ?? false) ...[
                      const SizedBox(height: 4),
                      Text(
                        person.knownForDepartment ?? '',
                        style: AppConfig.bodyStyle.copyWith(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                        maxLines: 1,
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