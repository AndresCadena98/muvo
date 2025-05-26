class Alarm {
  final int id;
  final String name;
  final DateTime time;
  final bool isActive;
  final List<String> days; // ['MON', 'TUE', etc.]
  final String? spotifyTrackId; // ID de la canción de Spotify (opcional)

  Alarm({
    required this.id,
    required this.name,
    required this.time,
    this.isActive = true,
    this.days = const [],
    this.spotifyTrackId,
  });

  Alarm copyWith({
    int? id,
    String? name,
    DateTime? time,
    bool? isActive,
    List<String>? days,
    String? spotifyTrackId,
  }) {
    return Alarm(
      id: id ?? this.id,
      name: name ?? this.name,
      time: time ?? this.time,
      isActive: isActive ?? this.isActive,
      days: days ?? this.days,
      spotifyTrackId: spotifyTrackId ?? this.spotifyTrackId,
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

  factory Alarm.fromJson(Map<String, dynamic> json) {
    return Alarm(
      id: int.parse(json['id'].toString()),
      name: json['name'] as String,
      time: DateTime.parse(json['time'] as String),
      isActive: json['isActive'] as bool,
      days: List<String>.from(json['days'] as List),
      spotifyTrackId: json['spotifyTrackId'] as String?,
    );
  }
} 