import 'package:flutter_dotenv/flutter_dotenv.dart';

class EnvConfig {
  static String get apiKey => dotenv.env['TMDB_API_KEY'] ?? '';
  
  static Future<void> init() async {
    await dotenv.load(fileName: '.env');
  }
} 