import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../providers/alarm_provider.dart';
import '../../domain/entities/alarm.dart';
import '../../core/constants/colors.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  bool _isDarkMode = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _showPremiumDialog(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final hasSeenDialog = prefs.getBool('has_seen_premium_dialog') ?? false;

    if (!hasSeenDialog) {
      if (context.mounted) {
        await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            title: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    Icons.star_rounded,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(width: 16),
                const Text('¡Cuenta Premium!'),
              ],
            ),
            content: const Text(
              '¡Necesitas una cuenta premium para personalizar los sonidos de tus alarmas!',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Entendido'),
              ),
            ],
          ),
        );
        await prefs.setBool('has_seen_premium_dialog', true);
      }
    }
  }

  String _getNextAlarmText(List<Alarm> alarms) {
    if (alarms.isEmpty) return 'No hay alarmas configuradas';
    
    final now = DateTime.now();
    final activeAlarms = alarms.where((alarm) => alarm.isActive).toList();
    if (activeAlarms.isEmpty) return 'No hay alarmas activas';

    activeAlarms.sort((a, b) => a.time.compareTo(b.time));
    final nextAlarm = activeAlarms.first;
    final nextAlarmTime = DateTime(
      now.year,
      now.month,
      now.day,
      nextAlarm.time.hour,
      nextAlarm.time.minute,
    );

    if (nextAlarmTime.isBefore(now)) {
      nextAlarmTime.add(const Duration(days: 1));
    }

    final difference = nextAlarmTime.difference(now);
    final hours = difference.inHours;
    final minutes = difference.inMinutes % 60;

    return 'Próxima alarma en $hours horas y $minutes minutos';
  }

  @override
  Widget build(BuildContext context) {
    final alarms = ref.watch(alarmsProvider);
    final theme = Theme.of(context);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showPremiumDialog(context);
    });

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      body: Stack(
        children: [
          // Fondo con patrón de puntos
          Positioned.fill(
            child: CustomPaint(
              painter: DotsPainter(
                color: theme.colorScheme.primary.withOpacity(0.1),
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Mis Alarmas',
                                style: theme.textTheme.headlineMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${alarms.length} alarmas configuradas',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: Colors.white.withOpacity(0.7),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              IconButton(
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(24),
                                      ),
                                      title: Row(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.all(12),
                                            decoration: BoxDecoration(
                                              color: theme.colorScheme.error.withOpacity(0.2),
                                              borderRadius: BorderRadius.circular(16),
                                            ),
                                            child: Icon(
                                              Icons.delete_sweep_rounded,
                                              color: theme.colorScheme.error,
                                            ),
                                          ),
                                          const SizedBox(width: 16),
                                          const Text('Limpiar Alarmas'),
                                        ],
                                      ),
                                      content: const Text(
                                        '¿Estás seguro de que deseas eliminar todas las alarmas? Esta acción no se puede deshacer.',
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () => Navigator.pop(context),
                                          child: Text(
                                            'Cancelar',
                                            style: TextStyle(
                                              color: theme.colorScheme.onSurface.withOpacity(0.7),
                                            ),
                                          ),
                                        ),
                                        TextButton(
                                          onPressed: () async {
                                            final prefs = await SharedPreferences.getInstance();
                                            await prefs.remove('alarms');
                                            ref.read(alarmsProvider.notifier).clearAlarms();
                                            if (context.mounted) {
                                              Navigator.pop(context);
                                            }
                                          },
                                          child: Text(
                                            'Limpiar',
                                            style: TextStyle(
                                              color: theme.colorScheme.error,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                                icon: Icon(
                                  Icons.delete_sweep_rounded,
                                  color: Colors.white,
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  setState(() {
                                    _isDarkMode = !_isDarkMode;
                                  });
                                },
                                icon: Icon(
                                  _isDarkMode ? Icons.light_mode : Icons.dark_mode,
                                  color: Colors.white,
                                ),
                              ),
                              IconButton(
                                onPressed: () => context.push('/stats'),
                                icon: Icon(
                                  Icons.bar_chart_rounded,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              theme.colorScheme.primary,
                              theme.colorScheme.primary.withOpacity(0.8),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: theme.colorScheme.primary.withOpacity(0.3),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: const Icon(
                                Icons.access_time_rounded,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Text(
                                _getNextAlarmText(alarms),
                                style: theme.textTheme.bodyLarge?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: alarms.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 120,
                                height: 120,
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.surface,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.white.withOpacity(0.1),
                                      blurRadius: 20,
                                      offset: const Offset(0, 10),
                                    ),
                                  ],
                                ),
                                child:const  Icon(
                                  Icons.alarm_off_rounded,
                                  size: 48,
                                  color: Colors.white,
                                ),
                              ),

                            ],
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          itemCount: alarms.length,
                          itemBuilder: (context, index) {
                            final alarm = alarms[index];
                            return AlarmTile(
                              alarm: alarm,
                              animationController: _animationController,
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'add',
        onPressed: () => context.push('/add-alarm'),
        icon: const Icon(Icons.add),
        label: const Text('Nueva Alarma'),
      ),
    );
  }
}

class DotsPainter extends CustomPainter {
  final Color color;

  DotsPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1;

    const spacing = 20.0;
    for (var i = 0.0; i < size.width; i += spacing) {
      for (var j = 0.0; j < size.height; j += spacing) {
        canvas.drawCircle(Offset(i, j), 1, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class AlarmTile extends ConsumerWidget {
  final Alarm alarm;
  final AnimationController animationController;

  const AlarmTile({
    super.key,
    required this.alarm,
    required this.animationController,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: theme.colorScheme.primary.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {},
            borderRadius: BorderRadius.circular(24),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              theme.colorScheme.primary,
                              theme.colorScheme.primary.withOpacity(0.8),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Stack(
                          children: [
                            Center(
                              child: Icon(
                                Icons.alarm_rounded,
                                color: Colors.white,
                                size: 28,
                              ),
                            ),
                            if (alarm.days.isNotEmpty)
                              Positioned(
                                right: 0,
                                bottom: 0,
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.repeat_rounded,
                                    color: theme.colorScheme.primary,
                                    size: 12,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${alarm.time.hour.toString().padLeft(2, '0')}:${alarm.time.minute.toString().padLeft(2, '0')}',
                              style: theme.textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              alarm.name,
                              style: theme.textTheme.titleMedium?.copyWith(
                                color: Colors.white.withOpacity(0.7),
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: theme.colorScheme.primary.withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        child: Switch(
                          value: alarm.isActive,
                          onChanged: (value) {
                            ref.read(alarmsProvider.notifier).toggleAlarm(alarm.id);
                          },
                          activeColor: Colors.white,
                          activeTrackColor: theme.colorScheme.primary,
                          inactiveThumbColor: Colors.white,
                          inactiveTrackColor: theme.colorScheme.onSurface.withOpacity(0.3),
                        ),
                      ),
                    ],
                  ),
                  if (alarm.days.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            alarm.days.join(", "),
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        const Spacer(),
                        Container(
                          decoration: BoxDecoration(
                            color: theme.colorScheme.error.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: theme.colorScheme.error.withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                          child: IconButton(
                            icon: Icon(
                              Icons.delete_outline_rounded,
                              color: theme.colorScheme.error,
                              size: 24,
                            ),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(24),
                                  ),
                                  title: Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                          color: theme.colorScheme.error.withOpacity(0.2),
                                          borderRadius: BorderRadius.circular(16),
                                        ),
                                        child: Icon(
                                          Icons.delete_outline_rounded,
                                          color: theme.colorScheme.error,
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      Expanded(
                                        child: Text(
                                          'Eliminar Alarma',
                                          style: TextStyle(
                                            color: theme.colorScheme.onSurface,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                  content: Text(
                                    '¿Estás seguro de que deseas eliminar la alarma "${alarm.name}"?',
                                    style: TextStyle(
                                      color: theme.colorScheme.onSurface,
                                    ),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: Text(
                                        'Cancelar',
                                        style: TextStyle(
                                          color: theme.colorScheme.onSurface.withOpacity(0.7),
                                        ),
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        ref.read(alarmsProvider.notifier).removeAlarm(alarm.id);
                                        Navigator.pop(context);
                                      },
                                      child: Text(
                                        'Eliminar',
                                        style: TextStyle(
                                          color: theme.colorScheme.error,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: List.generate(7, (index) {
                          final days = ['L', 'M', 'M', 'J', 'V', 'S', 'D'];
                          final isSelected = alarm.days.contains(days[index]);
                          return Container(
                            width: 24,
                            height: 24,
                            margin: const EdgeInsets.only(right: 4),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? theme.colorScheme.primary
                                  : theme.colorScheme.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Center(
                              child: Text(
                                days[index],
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: isSelected
                                      ? Colors.white
                                      : Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
} 