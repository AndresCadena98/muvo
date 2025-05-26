import 'package:flutter/material.dart';

abstract class NotificationInterface {
  Future<void> initialize();
  Future<void> showAlarmDialog(BuildContext context, String alarmName);
  Future<void> scheduleAlarm({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledTime,
    List<String> days = const [],
  });
  Future<void> cancelAlarm(int id, {List<String> days = const []});
} 