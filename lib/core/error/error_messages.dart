class ErrorMessages {
  // Errores de autenticación
  static const String authUserNotFound = 'No se encontró la cuenta de usuario';
  static const String authWrongPassword = 'Contraseña incorrecta';
  static const String authInvalidEmail = 'El correo electrónico no es válido';
  static const String authUserDisabled = 'La cuenta ha sido deshabilitada';
  static const String authTooManyRequests = 'Demasiados intentos. Por favor, espera un momento';
  static const String authOperationNotAllowed = 'Esta operación no está permitida';
  static const String authWeakPassword = 'La contraseña es demasiado débil';
  static const String authEmailAlreadyInUse = 'Este correo electrónico ya está en uso';
  static const String authAccountExistsWithDifferentCredential = 'Ya existe una cuenta con el mismo correo electrónico pero con diferentes credenciales';
  static const String authInvalidCredential = 'Las credenciales no son válidas';
  static const String authInvalidVerificationCode = 'Código de verificación inválido';
  static const String authInvalidVerificationId = 'ID de verificación inválido';
  static const String authGoogleSignInFailed = 'Error al iniciar sesión con Google';
  static const String authNotAuthenticated = 'Por favor, inicia sesión para continuar';

  // Errores de red
  static const String networkError = 'Error de conexión. Verifica tu conexión a internet';
  static const String timeoutError = 'La operación ha tardado demasiado. Por favor, intenta de nuevo';
  static const String serverError = 'Error del servidor. Por favor, intenta más tarde';

  // Errores de datos
  static const String dataNotFound = 'No se encontraron datos';
  static const String invalidData = 'Los datos no son válidos';
  static const String dataLoadError = 'Error al cargar los datos';

  // Errores de permisos
  static const String permissionDenied = 'Permiso denegado';
  static const String locationPermissionDenied = 'Se requiere acceso a la ubicación';
  static const String cameraPermissionDenied = 'Se requiere acceso a la cámara';

  // Errores de almacenamiento
  static const String storageError = 'Error al guardar los datos';
  static const String storageFull = 'No hay espacio suficiente';

  // Errores de validación
  static const String invalidInput = 'Datos de entrada inválidos';
  static const String requiredField = 'Este campo es requerido';
  static const String invalidFormat = 'Formato inválido';

  // Sugerencias para errores comunes
  static const String networkSuggestion = '• Verifica tu conexión a internet\n• Intenta nuevamente en unos momentos';
  static const String authSuggestion = '• Verifica tus credenciales\n• Asegúrate de que tu cuenta esté activa';
  static const String dataSuggestion = '• Intenta recargar la página\n• Verifica que los datos sean correctos';
} 