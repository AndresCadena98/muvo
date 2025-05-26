import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/alarm.dart';
import '../models/alarm_model.dart';

abstract class AlarmLocalDataSource {
  Future<List<Alarm>> getAlarms();
  Future<void> addAlarm(Alarm alarm);
  Future<void> updateAlarm(Alarm alarm);
  Future<void> removeAlarm(int id);
  Future<void> clearAlarms();
}

class AlarmLocalDataSourceImpl implements AlarmLocalDataSource {
  static const String _alarmsKey = 'alarms';
  final SharedPreferences _prefs;

  AlarmLocalDataSourceImpl(this._prefs);

  @override
  Future<List<Alarm>> getAlarms() async {
    final alarmsJson = _prefs.getStringList(_alarmsKey) ?? [];
    return alarmsJson
        .map((json) => AlarmModel.fromJson(jsonDecode(json)))
        .toList();
  }

  @override
  Future<void> addAlarm(Alarm alarm) async {
    final alarms = await getAlarms();
    alarms.add(AlarmModel.fromEntity(alarm));
    await _saveAlarms(alarms);
  }

  @override
  Future<void> updateAlarm(Alarm alarm) async {
    final alarms = await getAlarms();
    final index = alarms.indexWhere((a) => a.id == alarm.id);
    if (index != -1) {
      alarms[index] = AlarmModel.fromEntity(alarm);
      await _saveAlarms(alarms);
    }
  }

  @override
  Future<void> removeAlarm(int id) async {
    final alarms = await getAlarms();
    alarms.removeWhere((alarm) => alarm.id == id);
    await _saveAlarms(alarms);
  }

  @override
  Future<void> clearAlarms() async {
    await _prefs.remove(_alarmsKey);
  }

  Future<void> _saveAlarms(List<Alarm> alarms) async {
    final alarmsJson = alarms
        .map((alarm) => jsonEncode(AlarmModel.fromEntity(alarm).toJson()))
        .toList();
    await _prefs.setStringList(_alarmsKey, alarmsJson);
  }
} 