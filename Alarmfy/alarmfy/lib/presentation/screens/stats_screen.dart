import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/alarm_provider.dart';
import '../../core/constants/colors.dart';
import '../../domain/entities/alarm.dart';

class StatsScreen extends ConsumerWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final alarms = ref.watch(alarmsProvider);
    final theme = Theme.of(context);

    // Calcular estadísticas
    final totalAlarms = alarms.length;
    final activeAlarms = alarms.where((alarm) => alarm.isActive).toList().length;
    final weeklyAlarms = alarms.where((alarm) => alarm.days.isNotEmpty).toList().length;
    final oneTimeAlarms = alarms.where((alarm) => alarm.days.isEmpty).toList().length;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Estadísticas',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 24,
            color: AppColors.onBackground,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: AppColors.onBackground),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Resumen general
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppColors.onBackground.withOpacity(0.1),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Resumen General',
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: AppColors.onBackground,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: _StatCard(
                          icon: Icons.alarm_rounded,
                          title: 'Total',
                          value: totalAlarms.toString(),
                          color: AppColors.onBackground,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _StatCard(
                          icon: Icons.toggle_on_rounded,
                          title: 'Activas',
                          value: activeAlarms.toString(),
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _StatCard(
                          icon: Icons.repeat_rounded,
                          title: 'Semanal',
                          value: weeklyAlarms.toString(),
                          color: Colors.blue,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _StatCard(
                          icon: Icons.event_rounded,
                          title: 'Única',
                          value: oneTimeAlarms.toString(),
                          color: Colors.orange,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Distribución por hora
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppColors.onBackground.withOpacity(0.1),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Distribución por Hora',
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: AppColors.onBackground,
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    height: 200,
                    child: _HourDistributionChart(alarms: alarms),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Días más comunes
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppColors.onBackground.withOpacity(0.1),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Días más Comunes',
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: AppColors.onBackground,
                    ),
                  ),
                  const SizedBox(height: 24),
                  _DaysDistributionChart(alarms: alarms),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final Color color;

  const _StatCard({
    required this.icon,
    required this.title,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: color,
            size: 32,
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: color,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: color.withOpacity(0.7),
                ),
          ),
        ],
      ),
    );
  }
}

class _HourDistributionChart extends StatelessWidget {
  final List<Alarm> alarms;

  const _HourDistributionChart({
    required this.alarms,
  });

  @override
  Widget build(BuildContext context) {
    // Crear distribución de horas
    final hourDistribution = List.filled(24, 0);
    for (final alarm in alarms) {
      hourDistribution[alarm.time.hour]++;
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: List.generate(24, (index) {
        final count = hourDistribution[index];
        final maxCount = hourDistribution.reduce((a, b) => a > b ? a : b);
        final height = maxCount > 0 ? (count / maxCount) * 160 : 0.0;

        return Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              width: 8,
              height: height,
              decoration: BoxDecoration(
                color: AppColors.onBackground.withOpacity(0.7),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '${index.toString().padLeft(2, '0')}',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.onBackground.withOpacity(0.7),
                  ),
            ),
          ],
        );
      }),
    );
  }
}

class _DaysDistributionChart extends StatelessWidget {
  final List<Alarm> alarms;

  const _DaysDistributionChart({
    required this.alarms,
  });

  @override
  Widget build(BuildContext context) {
    final days = ['L', 'M', 'M', 'J', 'V', 'S', 'D'];
    final dayCounts = List.filled(7, 0);

    for (final alarm in alarms) {
      for (final day in alarm.days) {
        final index = days.indexOf(day);
        if (index != -1) {
          dayCounts[index]++;
        }
      }
    }

    final maxCount = dayCounts.reduce((a, b) => a > b ? a : b);

    return Column(
      children: List.generate(7, (index) {
        final count = dayCounts[index];
        final percentage = maxCount > 0 ? (count / maxCount) * 100 : 0.0;

        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Row(
            children: [
              SizedBox(
                width: 24,
                child: Text(
                  days[index],
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.onBackground,
                      ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Stack(
                  children: [
                    Container(
                      height: 24,
                      decoration: BoxDecoration(
                        color: AppColors.onBackground.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    Container(
                      height: 24,
                      width: percentage,
                      decoration: BoxDecoration(
                        color: AppColors.onBackground.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Text(
                count.toString(),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.onBackground,
                    ),
              ),
            ],
          ),
        );
      }),
    );
  }
} 