import 'package:flutter/material.dart';
import 'package:muvo/core/config/app_config.dart';
import 'package:muvo/core/l10n/app_localizations.dart';

class ErrorDisplay extends StatelessWidget {
  final String message;
  final String? suggestion;
  final IconData? icon;
  final Color? color;
  final VoidCallback? onRetry;

  const ErrorDisplay({
    super.key,
    required this.message,
    this.suggestion,
    this.icon,
    this.color,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon ?? Icons.error_outline_rounded,
              size: 48,
              color: color ?? Colors.red,
            ),
            const SizedBox(height: 16),
            Text(
              message,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: color ?? Colors.red,
              ),
              textAlign: TextAlign.center,
            ),
            if (suggestion != null) ...[
              const SizedBox(height: 8),
              Text(
                suggestion!,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: (color ?? Colors.red).withOpacity(0.8),
                ),
                textAlign: TextAlign.center,
              ),
            ],
            if (onRetry != null) ...[
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh_rounded),
                label: Text(l10n.retry),
                style: ElevatedButton.styleFrom(
                  foregroundColor: AppConfig.textPrimaryColor,
                  backgroundColor: (color ?? Colors.red).withOpacity(0.1),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
} 