import 'package:just_audio/just_audio.dart';
import 'dart:io';

class AlarmSoundService {
  static final AlarmSoundService _instance = AlarmSoundService._internal();
  factory AlarmSoundService() => _instance;
  AlarmSoundService._internal();

  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;

  Future<void> playAlarmSound() async {
    if (_isPlaying) return;

    try {
      _isPlaying = true;
      if (Platform.isAndroid) {
        await _audioPlayer.setAsset('assets/sounds/alarm.mp3');
      } else {
        await _audioPlayer.setAsset('assets/sounds/alarm.wav');
      }
      
      // Configurar el audio para que se repita
      await _audioPlayer.setLoopMode(LoopMode.all);
      
      // Reproducir el sonido
      await _audioPlayer.play();
      print('🔊 Sonido de alarma iniciado');
    } catch (e) {
      print('❌ Error al reproducir sonido de alarma: $e');
      _isPlaying = false;
    }
  }

  Future<void> stopAlarmSound() async {
    if (!_isPlaying) return;

    try {
      await _audioPlayer.stop();
      _isPlaying = false;
      print('🔇 Sonido de alarma detenido');
    } catch (e) {
      print('❌ Error al detener sonido de alarma: $e');
    }
  }

  Future<void> dispose() async {
    await _audioPlayer.dispose();
    _isPlaying = false;
  }
} 