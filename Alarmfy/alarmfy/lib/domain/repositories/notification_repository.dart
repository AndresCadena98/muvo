abstract class NotificationRepository {
  Future<void> initialize();
  Future<void> scheduleAlarm({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledTime,
    List<String> days = const [],
  });
  Future<void> cancelAlarm(int id, {List<String> days = const []});
  Future<bool> checkAndRequestPermissions();
} 