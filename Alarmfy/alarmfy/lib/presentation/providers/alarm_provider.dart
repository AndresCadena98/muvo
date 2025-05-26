import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/alarm.dart';
import '../../domain/repositories/alarm_repository.dart';
import '../../core/services/notification_service.dart';

class AlarmNotifier extends StateNotifier<List<Alarm>> {
  final AlarmRepository repository;
  final NotificationService notifications;

  AlarmNotifier(this.repository, this.notifications) : super([]) {
    _loadAlarms();
  }

  Future<void> _loadAlarms() async {
    final alarms = await repository.getAlarms();
    state = alarms;
  }

  Future<void> addAlarm(Alarm alarm) async {
    await repository.addAlarm(alarm);
    if (alarm.isActive) {
      await notifications.scheduleAlarm(
        id: alarm.id,
        title: alarm.name,
        body: '¡Es hora de tu alarma!',
        scheduledTime: alarm.time,
        days: alarm.days,
      );
    }
    state = [...state, alarm];
  }

  Future<void> removeAlarm(int id) async {
    final alarm = state.firstWhere((alarm) => alarm.id == id);
    await repository.removeAlarm(id);
    await notifications.cancelAlarm(id, days: alarm.days);
    state = state.where((alarm) => alarm.id != id).toList();
  }

  Future<void> updateAlarm(Alarm updatedAlarm) async {
    final oldAlarm = state.firstWhere((alarm) => alarm.id == updatedAlarm.id);
    await repository.updateAlarm(updatedAlarm);
    
    // Cancelar la alarma antigua
    await notifications.cancelAlarm(updatedAlarm.id, days: oldAlarm.days);
    
    // Programar la nueva alarma si está activa
    if (updatedAlarm.isActive) {
      await notifications.scheduleAlarm(
        id: updatedAlarm.id,
        title: updatedAlarm.name,
        body: '¡Es hora de tu alarma!',
        scheduledTime: updatedAlarm.time,
        days: updatedAlarm.days,
      );
    }
    
    state = state.map((alarm) {
      return alarm.id == updatedAlarm.id ? updatedAlarm : alarm;
    }).toList();
  }

  Future<void> toggleAlarm(int id) async {
    await repository.toggleAlarm(id);
    await _loadAlarms();
  }

  Future<void> clearAlarms() async {
    final alarms = state;
    for (final alarm in alarms) {
      await notifications.cancelAlarm(alarm.id, days: alarm.days);
    }
    state = [];
  }
}

final notificationServiceProvider = Provider<NotificationService>((ref) {
  return NotificationService();
});

final alarmRepositoryProvider = Provider<AlarmRepository>((ref) {
  throw UnimplementedError('AlarmRepository debe ser inicializado');
});

final alarmsProvider = StateNotifierProvider<AlarmNotifier, List<Alarm>>((ref) {
  final repository = ref.watch(alarmRepositoryProvider);
  final notifications = ref.watch(notificationServiceProvider);
  return AlarmNotifier(repository, notifications);
}); 