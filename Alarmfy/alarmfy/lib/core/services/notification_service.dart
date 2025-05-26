import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:convert';
import '../../domain/entities/alarm.dart';
import '../../domain/repositories/notification_repository.dart';
import '../interfaces/notification_interface.dart';
import 'alarm_sound_service.dart';
import 'navigation_service.dart';

// Manejador de notificaciones en segundo plano
@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse response) {
  print('👆 Notificación tocada en segundo plano: ${response.payload}');
}

class NotificationService implements NotificationInterface {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notifications = FlutterLocalNotificationsPlugin();
  final DeviceInfoPlugin _deviceInfo = DeviceInfoPlugin();
  final AlarmSoundService _alarmSound = AlarmSoundService();
  final NavigationService _navigation = NavigationService();
  static const String _channelId = 'alarm_channel';
  static const String _channelName = 'Alarmas';
  static const String _channelDescription = 'Canal para las alarmas de la aplicación';

  @override
  Future<void> showAlarmDialog(BuildContext context, String alarmName) async {
    // Iniciar el sonido de la alarma
    await _alarmSound.playAlarmSound();

    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
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
                  Icons.alarm_rounded,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              const SizedBox(width: 16),
              const Text('¡Es hora de tu alarma!'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                alarmName,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: () async {
                      await _alarmSound.stopAlarmSound();
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(Icons.snooze_rounded),
                    label: const Text('Posponer'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Colors.white,
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () async {
                      await _alarmSound.stopAlarmSound();
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(Icons.stop_rounded),
                    label: const Text('Detener'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.error,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Future<void> scheduleAlarm({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledTime,
    List<String> days = const [],
  }) async {
    print('\n⏰ ===== PROGRAMANDO ALARMA =====');
    print('📅 Fecha actual: ${DateTime.now().toLocal()}');
    print('📅 Fecha programada: ${scheduledTime.toLocal()}');
    print('📅 Días: ${days.isEmpty ? "Una sola vez" : days.join(", ")}');
    
    final safeId = id % (1 << 31);
    
    try {
      final permissionsGranted = await checkAndRequestPermissions();
      if (!permissionsGranted) {
        print('⚠️ No se pueden programar alarmas: permisos no concedidos');
        return;
      }

      if (days.isEmpty) {
        await _scheduleSingleAlarm(safeId, title, body, scheduledTime);
      } else {
        for (final day in days) {
          final dayId = safeId + _getDayOffset(day);
          await _scheduleSingleAlarm(dayId, title, body, scheduledTime);
        }
      }
    } catch (e) {
      print('❌ Error al programar alarma: $e');
      if (e.toString().contains('exact_alarms_not_permitted')) {
        if (days.isEmpty) {
          await _scheduleSingleAlarm(safeId, title, body, scheduledTime, isExact: false);
        } else {
          for (final day in days) {
            final dayId = safeId + _getDayOffset(day);
            await _scheduleSingleAlarm(dayId, title, body, scheduledTime, isExact: false);
          }
        }
      } else {
        rethrow;
      }
    }
  }

  @override
  Future<void> cancelAlarm(int id, {List<String> days = const []}) async {
    if (days.isEmpty) {
      await _notifications.cancel(id);
    } else {
      for (final day in days) {
        final dayId = id + _getDayOffset(day);
        await _notifications.cancel(dayId);
      }
    }
  }

  @override
  Future<void> initialize() async {
    try {
      tz.initializeTimeZones();
      await AndroidAlarmManager.initialize();
      
      if (Platform.isAndroid) {
        final androidPlugin = _notifications
            .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
            
        await androidPlugin?.createNotificationChannel(
          const AndroidNotificationChannel(
            _channelId,
            _channelName,
            description: _channelDescription,
            importance: Importance.max,
            playSound: true,
            enableVibration: true,
            enableLights: true,
            showBadge: true,
            sound: RawResourceAndroidNotificationSound('alarm'),
          ),
        );

        final exactAlarmsGranted = await androidPlugin?.requestExactAlarmsPermission();
        final notificationsGranted = await androidPlugin?.requestNotificationsPermission();
      }

      const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
      const iosSettings = DarwinInitializationSettings(
        requestSoundPermission: true,
        requestBadgePermission: true,
        requestAlertPermission: true,
        defaultPresentAlert: true,
        defaultPresentBadge: true,
        defaultPresentSound: true,
      );

      const initSettings = InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
      );

      await _notifications.initialize(
        initSettings,
        onDidReceiveNotificationResponse: _onNotificationTapped,
        onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
      );

      final permissionsGranted = await checkAndRequestPermissions();
      if (!permissionsGranted) {
        print('⚠️ Los permisos de notificación no fueron concedidos');
      }
    } catch (e) {
      print('❌ Error al inicializar el servicio de notificaciones: $e');
    }
  }

  // Métodos privados auxiliares
  Future<void> _scheduleSingleAlarm(
    int id,
    String title,
    String body,
    DateTime scheduledTime, {
    bool isExact = true,
  }) async {
    try {
      final localTime = tz.TZDateTime(
        tz.local,
        scheduledTime.year,
        scheduledTime.month,
        scheduledTime.day,
        scheduledTime.hour,
        scheduledTime.minute,
        scheduledTime.second,
      );
      
      if (Platform.isAndroid) {
        await AndroidAlarmManager.oneShotAt(
          localTime,
          id,
          _showAlarmNotification,
          exact: isExact,
          wakeup: true,
          rescheduleOnReboot: true,
          params: {
            'title': title,
            'body': body,
          },
        );
      }
      
      await _notifications.zonedSchedule(
        id,
        title,
        body,
        localTime,
        NotificationDetails(
          android: AndroidNotificationDetails(
            _channelId,
            _channelName,
            channelDescription: _channelDescription,
            importance: Importance.max,
            priority: Priority.max,
            fullScreenIntent: true,
            category: AndroidNotificationCategory.alarm,
            visibility: NotificationVisibility.public,
            playSound: true,
            enableVibration: true,
            enableLights: true,
            sound: const RawResourceAndroidNotificationSound('alarm'),
            showWhen: true,
            autoCancel: false,
            ongoing: true,
            styleInformation: BigTextStyleInformation(body),
            actions: <AndroidNotificationAction>[
              const AndroidNotificationAction('dismiss', 'Desactivar'),
              const AndroidNotificationAction('snooze', 'Posponer'),
            ],
          ),
          iOS: const DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
            interruptionLevel: InterruptionLevel.timeSensitive,
            sound: 'alarm.wav',
          ),
        ),
        androidScheduleMode: isExact
            ? AndroidScheduleMode.exactAllowWhileIdle
            : AndroidScheduleMode.inexactAllowWhileIdle,
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
      );
    } catch (e) {
      print('❌ Error al programar la alarma: $e');
      rethrow;
    }
  }

  @pragma('vm:entry-point')
  Future<void> _showAlarmNotification(int id, Map<String, dynamic>? params) async {
    final now = DateTime.now();
    final title = params?['title'] as String? ?? '¡Es hora de tu alarma!';
    final body = params?['body'] as String? ?? 'Tu alarma ha sonado';

    await showImmediateNotification(
      title: title,
      body: body,
      payload: json.encode({
        'id': id,
        'title': title,
        'body': body,
        'timestamp': now.toIso8601String(),
      }),
    );
    
    await _alarmSound.playAlarmSound();
  }

  Future<void> showImmediateNotification({
    required String title,
    required String body,
    String? payload,
  }) async {
    try {
      final permissionsGranted = await checkAndRequestPermissions();
      if (!permissionsGranted) return;

      const androidDetails = AndroidNotificationDetails(
        _channelId,
        _channelName,
        channelDescription: _channelDescription,
        importance: Importance.max,
        priority: Priority.max,
        showWhen: true,
        enableVibration: true,
        playSound: true,
        sound: RawResourceAndroidNotificationSound('alarm'),
        fullScreenIntent: true,
        category: AndroidNotificationCategory.alarm,
        visibility: NotificationVisibility.public,
        actions: <AndroidNotificationAction>[
          AndroidNotificationAction('dismiss', 'Desactivar'),
          AndroidNotificationAction('snooze', 'Posponer'),
        ],
        styleInformation: BigTextStyleInformation(''),
        ongoing: true,
        autoCancel: false,
        ticker: 'Alarma activa',
      );

      const iosDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
        sound: 'alarm.wav',
        interruptionLevel: InterruptionLevel.timeSensitive,
        categoryIdentifier: 'alarm',
        threadIdentifier: 'alarm_thread',
      );

      final notificationId = DateTime.now().millisecondsSinceEpoch.remainder(100000);

      await _notifications.show(
        notificationId,
        title,
        body,
        const NotificationDetails(
          android: androidDetails,
          iOS: iosDetails,
        ),
        payload: payload,
      );
    } catch (e) {
      print('❌ Error al mostrar notificación inmediata: $e');
    }
  }

  void _onNotificationTapped(NotificationResponse response) async {
    switch (response.actionId) {
      case 'dismiss':
        await _alarmSound.stopAlarmSound();
        break;
      case 'snooze':
        await _alarmSound.stopAlarmSound();
        break;
      default:
        if (response.payload != null) {
          try {
            final Map<String, dynamic> payload = json.decode(response.payload!);
            final context = _navigation.currentContext;
            if (context != null) {
              await showAlarmDialog(context, payload['title'] as String);
            }
          } catch (e) {
            print('❌ Error al decodificar el payload: $e');
          }
        }
        break;
    }
  }

  Future<bool> checkAndRequestPermissions() async {
    try {
      if (Platform.isAndroid) {
        final androidInfo = await _deviceInfo.androidInfo;
        if (androidInfo.version.sdkInt >= 33) {
          final bool? granted = await _notifications
              .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
              ?.requestNotificationsPermission();
          return granted ?? false;
        }
        return true;
      } else if (Platform.isIOS) {
        final bool? granted = await _notifications
            .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()
            ?.requestPermissions(
              alert: true,
              badge: true,
              sound: true,
            );
        return granted ?? false;
      }
      return false;
    } catch (e) {
      print('❌ Error al verificar permisos: $e');
      return false;
    }
  }

  int _getDayOffset(String day) {
    final days = ['LUN', 'MAR', 'MIE', 'JUE', 'VIE', 'SAB', 'DOM'];
    return days.indexOf(day) * 1000;
  }
} 