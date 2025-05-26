import '../../domain/entities/alarm.dart';
import '../../domain/repositories/alarm_repository.dart';
import '../datasources/alarm_local_datasource.dart';

class AlarmRepositoryImpl implements AlarmRepository {
  final AlarmLocalDataSource localDataSource;

  AlarmRepositoryImpl(this.localDataSource);

  @override
  Future<List<Alarm>> getAlarms() async {
    return await localDataSource.getAlarms();
  }

  @override
  Future<void> addAlarm(Alarm alarm) async {
    await localDataSource.addAlarm(alarm);
  }

  @override
  Future<void> updateAlarm(Alarm alarm) async {
    await localDataSource.updateAlarm(alarm);
  }

  @override
  Future<void> removeAlarm(int id) async {
    await localDataSource.removeAlarm(id);
  }

  @override
  Future<void> toggleAlarm(int id) async {
    final alarms = await getAlarms();
    final alarm = alarms.firstWhere((alarm) => alarm.id == id);
    final updatedAlarm = alarm.copyWith(isActive: !alarm.isActive);
    await updateAlarm(updatedAlarm);
  }

  @override
  Future<void> clearAlarms() async {
    await localDataSource.clearAlarms();
  }
} 