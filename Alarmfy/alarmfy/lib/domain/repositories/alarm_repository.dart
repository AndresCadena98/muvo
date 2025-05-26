import '../entities/alarm.dart';

abstract class AlarmRepository {
  Future<List<Alarm>> getAlarms();
  Future<void> addAlarm(Alarm alarm);
  Future<void> updateAlarm(Alarm alarm);
  Future<void> removeAlarm(int id);
  Future<void> toggleAlarm(int id);
  Future<void> clearAlarms();
} 