import 'package:firebase_auth/firebase_auth.dart';
import 'package:muvo/core/services/language_service.dart';
import 'package:get_it/get_it.dart';

class AppException implements Exception {
  final String message;
  final String? suggestion;
  final dynamic originalError;

  AppException({
    required this.message,
    this.suggestion,
    this.originalError,
  });

  factory AppException.fromFirebaseAuthException(FirebaseAuthException e) {
    final languageService = GetIt.I<LanguageService>();
    final locale = languageService.currentLocale;
    String message;
    String? suggestion;

    switch (e.code) {
      case 'user-not-found':
        message = locale.languageCode == 'es' 
            ? 'No se encontró la cuenta de usuario'
            : 'User account not found';
        suggestion = locale.languageCode == 'es'
            ? 'Verifica tus credenciales\n• Asegúrate de que tu cuenta esté activa'
            : '• Verify your credentials\n• Make sure your account is active';
        break;
      case 'wrong-password':
        message = locale.languageCode == 'es'
            ? 'Contraseña incorrecta'
            : 'Wrong password';
        suggestion = locale.languageCode == 'es'
            ? 'Verifica tus credenciales\n• Asegúrate de que tu cuenta esté activa'
            : '• Verify your credentials\n• Make sure your account is active';
        break;
      case 'invalid-email':
        message = locale.languageCode == 'es'
            ? 'El correo electrónico no es válido'
            : 'Invalid email address';
        suggestion = locale.languageCode == 'es'
            ? 'Verifica tus credenciales\n• Asegúrate de que tu cuenta esté activa'
            : '• Verify your credentials\n• Make sure your account is active';
        break;
      case 'user-disabled':
        message = locale.languageCode == 'es'
            ? 'La cuenta ha sido deshabilitada'
            : 'Account has been disabled';
        suggestion = locale.languageCode == 'es'
            ? 'Verifica tus credenciales\n• Asegúrate de que tu cuenta esté activa'
            : '• Verify your credentials\n• Make sure your account is active';
        break;
      case 'too-many-requests':
        message = locale.languageCode == 'es'
            ? 'Demasiados intentos. Por favor, espera un momento'
            : 'Too many attempts. Please wait a moment';
        suggestion = locale.languageCode == 'es'
            ? 'Verifica tus credenciales\n• Asegúrate de que tu cuenta esté activa'
            : '• Verify your credentials\n• Make sure your account is active';
        break;
      case 'operation-not-allowed':
        message = locale.languageCode == 'es'
            ? 'Esta operación no está permitida'
            : 'This operation is not allowed';
        suggestion = locale.languageCode == 'es'
            ? 'Verifica tus credenciales\n• Asegúrate de que tu cuenta esté activa'
            : '• Verify your credentials\n• Make sure your account is active';
        break;
      case 'weak-password':
        message = locale.languageCode == 'es'
            ? 'La contraseña es demasiado débil'
            : 'Password is too weak';
        suggestion = locale.languageCode == 'es'
            ? 'Verifica tus credenciales\n• Asegúrate de que tu cuenta esté activa'
            : '• Verify your credentials\n• Make sure your account is active';
        break;
      case 'email-already-in-use':
        message = locale.languageCode == 'es'
            ? 'Este correo electrónico ya está en uso'
            : 'Email is already in use';
        suggestion = locale.languageCode == 'es'
            ? 'Verifica tus credenciales\n• Asegúrate de que tu cuenta esté activa'
            : '• Verify your credentials\n• Make sure your account is active';
        break;
      case 'account-exists-with-different-credential':
        message = locale.languageCode == 'es'
            ? 'Ya existe una cuenta con el mismo correo electrónico'
            : 'Account already exists with this email';
        suggestion = locale.languageCode == 'es'
            ? 'Verifica tus credenciales\n• Asegúrate de que tu cuenta esté activa'
            : '• Verify your credentials\n• Make sure your account is active';
        break;
      case 'invalid-credential':
        message = locale.languageCode == 'es'
            ? 'Las credenciales no son válidas'
            : 'Invalid credentials';
        suggestion = locale.languageCode == 'es'
            ? 'Verifica tus credenciales\n• Asegúrate de que tu cuenta esté activa'
            : '• Verify your credentials\n• Make sure your account is active';
        break;
      case 'invalid-verification-code':
        message = locale.languageCode == 'es'
            ? 'Código de verificación inválido'
            : 'Invalid verification code';
        suggestion = locale.languageCode == 'es'
            ? 'Verifica tus credenciales\n• Asegúrate de que tu cuenta esté activa'
            : '• Verify your credentials\n• Make sure your account is active';
        break;
      case 'invalid-verification-id':
        message = locale.languageCode == 'es'
            ? 'ID de verificación inválido'
            : 'Invalid verification ID';
        suggestion = locale.languageCode == 'es'
            ? 'Verifica tus credenciales\n• Asegúrate de que tu cuenta esté activa'
            : '• Verify your credentials\n• Make sure your account is active';
        break;
      default:
        message = locale.languageCode == 'es'
            ? 'Por favor, inicia sesión para continuar'
            : 'Please login to continue';
        suggestion = locale.languageCode == 'es'
            ? 'Verifica tus credenciales\n• Asegúrate de que tu cuenta esté activa'
            : '• Verify your credentials\n• Make sure your account is active';
    }

    return AppException(
      message: message,
      suggestion: suggestion,
      originalError: e,
    );
  }

  factory AppException.networkError() {
    final languageService = GetIt.I<LanguageService>();
    final locale = languageService.currentLocale;
    return AppException(
      message: locale.languageCode == 'es'
          ? 'Error de conexión. Verifica tu conexión a internet'
          : 'Connection error. Check your internet connection',
      suggestion: locale.languageCode == 'es'
          ? '• Verifica tu conexión a internet\n• Intenta nuevamente en unos momentos'
          : '• Check your internet connection\n• Try again in a few moments',
    );
  }

  factory AppException.serverError() {
    final languageService = GetIt.I<LanguageService>();
    final locale = languageService.currentLocale;
    return AppException(
      message: locale.languageCode == 'es'
          ? 'Error del servidor. Por favor, intenta más tarde'
          : 'Server error. Please try again later',
      suggestion: locale.languageCode == 'es'
          ? '• Intenta recargar la página\n• Verifica que los datos sean correctos'
          : '• Try reloading the page\n• Verify that the data is correct',
    );
  }

  factory AppException.unknownError([dynamic error]) {
    final languageService = GetIt.I<LanguageService>();
    final locale = languageService.currentLocale;
    return AppException(
      message: locale.languageCode == 'es'
          ? 'Error al cargar los datos'
          : 'Error loading data',
      suggestion: locale.languageCode == 'es'
          ? '• Intenta recargar la página\n• Verifica que los datos sean correctos'
          : '• Try reloading the page\n• Verify that the data is correct',
      originalError: error,
    );
  }

  @override
  String toString() => message;
} 