import 'package:flutter_test/flutter_test.dart';
import 'package:muvo/core/config/env_config.dart';

void main() {
  group('EnvConfig', () {
    test('should load environment variables', () async {
      try {
        // Arrange
        await EnvConfig.init();
        
        // Act
        final apiKey = EnvConfig.apiKey;
        
        // Assert
        expect(apiKey, isNotEmpty);
        print('API Key loaded successfully: ${apiKey.substring(0, 4)}...');
      } catch (e) {
        fail('Error loading .env file: $e');
      }
    });
  });
} 