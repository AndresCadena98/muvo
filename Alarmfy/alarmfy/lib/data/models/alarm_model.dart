import '../../domain/entities/alarm.dart';

class AlarmModel extends Alarm {
  AlarmModel({
    required super.id,
    required super.name,
    required super.time,
    super.isActive = true,
    super.days = const [],
    super.spotifyTrackId,
  });

  factory AlarmModel.fromJson(Map<String, dynamic> json) {
    return AlarmModel(
      id: int.parse(json['id'].toString()),
      name: json['name'] as String,
      time: DateTime.parse(json['time'] as String),
      isActive: json['isActive'] as bool,
      days: List<String>.from(json['days'] as List),
      spotifyTrackId: json['spotifyTrackId'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'time': time.toIso8601String(),
      'isActive': isActive,
      'days': days,
      'spotifyTrackId': spotifyTrackId,
    };
  }

  factory AlarmModel.fromEntity(Alarm alarm) {
    return AlarmModel(
      id: alarm.id,
      name: alarm.name,
      time: alarm.time,
      isActive: alarm.isActive,
      days: alarm.days,
      spotifyTrackId: alarm.spotifyTrackId,
    );
  }
} 