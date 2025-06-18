import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;
  
  AppLocalizations(this.locale);
  
  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }
  
  static const _localizedValues = <String, Map<String, String>>{
    'es': {
      'app_name': 'Muvo',
      'settings': 'Ajustes',
      'language': 'Idioma',
      'notifications': 'Notificaciones',
      'profile': 'Perfil',
      'privacy': 'Privacidad',
      'login': 'Iniciar sesión',
      'register': 'Crear cuenta',
      'welcome_back': 'Bienvenido de nuevo',
      'join_community': 'Únete a nuestra comunidad',
      'movies': 'Películas',
      'favorites': 'Favoritos',
      'search': 'Buscar',
      'popular': 'Populares',
      'upcoming': 'Próximamente',
      'top_rated': 'Mejor valoradas',
      'account': 'Cuenta',
      'logout': 'Cerrar sesión',
      'logoutMessage': 'Salir de tu cuenta',
      'logoutConfirmation': '¿Estás seguro de que deseas cerrar sesión?',
      'cancel': 'Cancelar',
      'signOut': 'Cerrar sesión',
      'customizeExperience': 'Personaliza tu experiencia',
      'explore': 'Explorar',
      'discover_movies': 'Descubre nuevas películas',
      'search_movies': 'Buscar películas...',
      'retry': 'Reintentar',
      'error': 'Error',
      'email': 'Correo electrónico',
      'email_hint': 'ejemplo@correo.com',
      'email_required': 'Ingresa tu correo',
      'email_invalid': 'Correo no válido',
      'password': 'Contraseña',
      'password_hint': '••••••••',
      'password_required': 'Ingresa tu contraseña',
      'password_min_length': 'Mínimo 6 caracteres',
      'forgot_password': '¿Olvidaste tu contraseña?',
      'continue_with': 'O continúa con',
      'already_have_account': '¿Ya tienes cuenta? Inicia sesión',
      'no_account': '¿No tienes cuenta? Regístrate',
      'no_email': 'Sin correo',
      'user': 'Usuario',
      'notifications_enabled': 'Activadas',
      'spanish': 'Español',
      'english': 'English',
      'no_internet': 'Sin conexión a internet',
      'auth_user_not_found': 'No se encontró la cuenta de usuario',
      'auth_wrong_password': 'Contraseña incorrecta',
      'auth_invalid_email': 'El correo electrónico no es válido',
      'auth_user_disabled': 'La cuenta ha sido deshabilitada',
      'auth_too_many_requests': 'Demasiados intentos. Por favor, espera un momento',
      'auth_operation_not_allowed': 'Esta operación no está permitida',
      'auth_weak_password': 'La contraseña es demasiado débil',
      'auth_email_already_in_use': 'Este correo electrónico ya está en uso',
      'auth_account_exists': 'Ya existe una cuenta con el mismo correo electrónico',
      'auth_invalid_credential': 'Las credenciales no son válidas',
      'auth_invalid_verification_code': 'Código de verificación inválido',
      'auth_invalid_verification_id': 'ID de verificación inválido',
      'auth_google_sign_in_failed': 'Error al iniciar sesión con Google',
      'auth_not_authenticated': 'Por favor, inicia sesión para continuar',
      'network_error': 'Error de conexión. Verifica tu conexión a internet',
      'timeout_error': 'La operación ha tardado demasiado. Por favor, intenta de nuevo',
      'server_error': 'Error del servidor. Por favor, intenta más tarde',
      'data_not_found': 'No se encontraron datos',
      'invalid_data': 'Los datos no son válidos',
      'data_load_error': 'Error al cargar los datos',
      'permission_denied': 'Permiso denegado',
      'location_permission_denied': 'Se requiere acceso a la ubicación',
      'camera_permission_denied': 'Se requiere acceso a la cámara',
      'storage_error': 'Error al guardar los datos',
      'storage_full': 'No hay espacio suficiente',
      'invalid_input': 'Datos de entrada inválidos',
      'required_field': 'Este campo es requerido',
      'invalid_format': 'Formato inválido',
      'network_suggestion': '• Verifica tu conexión a internet\n• Intenta nuevamente en unos momentos',
      'auth_suggestion': '• Verifica tus credenciales\n• Asegúrate de que tu cuenta esté activa',
      'data_suggestion': '• Intenta recargar la página\n• Verifica que los datos sean correctos',
    },
    'en': {
      'app_name': 'Muvo',
      'settings': 'Settings',
      'language': 'Language',
      'notifications': 'Notifications',
      'profile': 'Profile',
      'privacy': 'Privacy',
      'login': 'Login',
      'register': 'Register',
      'welcome_back': 'Welcome back',
      'join_community': 'Join our community',
      'movies': 'Movies',
      'favorites': 'Favorites',
      'search': 'Search',
      'popular': 'Popular',
      'upcoming': 'Upcoming',
      'top_rated': 'Top Rated',
      'account': 'Account',
      'logout': 'Logout',
      'logoutMessage': 'Sign out of your account',
      'logoutConfirmation': 'Are you sure you want to sign out?',
      'cancel': 'Cancel',
      'signOut': 'Sign Out',
      'customizeExperience': 'Customize your experience',
      'explore': 'Explore',
      'discover_movies': 'Discover new movies',
      'search_movies': 'Search movies...',
      'retry': 'Retry',
      'error': 'Error',
      'email': 'Email',
      'email_hint': 'example@email.com',
      'email_required': 'Enter your email',
      'email_invalid': 'Invalid email',
      'password': 'Password',
      'password_hint': '••••••••',
      'password_required': 'Enter your password',
      'password_min_length': 'Minimum 6 characters',
      'forgot_password': 'Forgot your password?',
      'continue_with': 'Or continue with',
      'already_have_account': 'Already have an account? Login',
      'no_account': 'Don\'t have an account? Register',
      'no_email': 'No email',
      'user': 'User',
      'notifications_enabled': 'Enabled',
      'spanish': 'Spanish',
      'english': 'English',
      'no_internet': 'No internet connection',
      'auth_user_not_found': 'User account not found',
      'auth_wrong_password': 'Wrong password',
      'auth_invalid_email': 'Invalid email address',
      'auth_user_disabled': 'Account has been disabled',
      'auth_too_many_requests': 'Too many attempts. Please wait a moment',
      'auth_operation_not_allowed': 'This operation is not allowed',
      'auth_weak_password': 'Password is too weak',
      'auth_email_already_in_use': 'Email is already in use',
      'auth_account_exists': 'Account already exists with this email',
      'auth_invalid_credential': 'Invalid credentials',
      'auth_invalid_verification_code': 'Invalid verification code',
      'auth_invalid_verification_id': 'Invalid verification ID',
      'auth_google_sign_in_failed': 'Google sign in failed',
      'auth_not_authenticated': 'Please login to continue',
      'network_error': 'Connection error. Check your internet connection',
      'timeout_error': 'Operation timed out. Please try again',
      'server_error': 'Server error. Please try again later',
      'data_not_found': 'No data found',
      'invalid_data': 'Invalid data',
      'data_load_error': 'Error loading data',
      'permission_denied': 'Permission denied',
      'location_permission_denied': 'Location access required',
      'camera_permission_denied': 'Camera access required',
      'storage_error': 'Error saving data',
      'storage_full': 'Not enough storage space',
      'invalid_input': 'Invalid input data',
      'required_field': 'This field is required',
      'invalid_format': 'Invalid format',
      'network_suggestion': '• Check your internet connection\n• Try again in a few moments',
      'auth_suggestion': '• Verify your credentials\n• Make sure your account is active',
      'data_suggestion': '• Try reloading the page\n• Verify that the data is correct',
    },
  };
  
  String get appName => _localizedValues[locale.languageCode]!['app_name']!;
  String get settings => _localizedValues[locale.languageCode]!['settings']!;
  String get language => _localizedValues[locale.languageCode]!['language']!;
  String get notifications => _localizedValues[locale.languageCode]!['notifications']!;
  String get profile => _localizedValues[locale.languageCode]!['profile']!;
  String get privacy => _localizedValues[locale.languageCode]!['privacy']!;
  String get login => _localizedValues[locale.languageCode]!['login']!;
  String get register => _localizedValues[locale.languageCode]!['register']!;
  String get welcomeBack => _localizedValues[locale.languageCode]!['welcome_back']!;
  String get joinCommunity => _localizedValues[locale.languageCode]!['join_community']!;
  String get movies => _localizedValues[locale.languageCode]!['movies']!;
  String get favorites => _localizedValues[locale.languageCode]!['favorites']!;
  String get search => _localizedValues[locale.languageCode]!['search']!;
  String get popular => _localizedValues[locale.languageCode]!['popular']!;
  String get upcoming => _localizedValues[locale.languageCode]!['upcoming']!;
  String get topRated => _localizedValues[locale.languageCode]!['top_rated']!;
  String get account => _localizedValues[locale.languageCode]!['account']!;
  String get logout => _localizedValues[locale.languageCode]!['logout']!;
  String get logoutMessage => _localizedValues[locale.languageCode]!['logoutMessage']!;
  String get logoutConfirmation => _localizedValues[locale.languageCode]!['logoutConfirmation']!;
  String get cancel => _localizedValues[locale.languageCode]!['cancel']!;
  String get signOut => _localizedValues[locale.languageCode]!['signOut']!;
  String get customizeExperience => _localizedValues[locale.languageCode]!['customizeExperience']!;
  String get explore => _localizedValues[locale.languageCode]!['explore']!;
  String get discoverMovies => _localizedValues[locale.languageCode]!['discover_movies']!;
  String get searchMovies => _localizedValues[locale.languageCode]!['search_movies']!;
  String get retry => _localizedValues[locale.languageCode]!['retry']!;
  String get error => _localizedValues[locale.languageCode]!['error']!;
  String get email => _localizedValues[locale.languageCode]!['email']!;
  String get emailHint => _localizedValues[locale.languageCode]!['email_hint']!;
  String get emailRequired => _localizedValues[locale.languageCode]!['email_required']!;
  String get emailInvalid => _localizedValues[locale.languageCode]!['email_invalid']!;
  String get password => _localizedValues[locale.languageCode]!['password']!;
  String get passwordHint => _localizedValues[locale.languageCode]!['password_hint']!;
  String get passwordRequired => _localizedValues[locale.languageCode]!['password_required']!;
  String get passwordMinLength => _localizedValues[locale.languageCode]!['password_min_length']!;
  String get forgotPassword => _localizedValues[locale.languageCode]!['forgot_password']!;
  String get continueWith => _localizedValues[locale.languageCode]!['continue_with']!;
  String get alreadyHaveAccount => _localizedValues[locale.languageCode]!['already_have_account']!;
  String get noAccount => _localizedValues[locale.languageCode]!['no_account']!;
  String get noEmail => _localizedValues[locale.languageCode]!['no_email']!;
  String get user => _localizedValues[locale.languageCode]!['user']!;
  String get notificationsEnabled => _localizedValues[locale.languageCode]!['notifications_enabled']!;
  String get spanish => _localizedValues[locale.languageCode]!['spanish']!;
  String get english => _localizedValues[locale.languageCode]!['english']!;
  String get noInternet => _localizedValues[locale.languageCode]!['no_internet']!;
  String get authUserNotFound => _localizedValues[locale.languageCode]!['auth_user_not_found']!;
  String get authWrongPassword => _localizedValues[locale.languageCode]!['auth_wrong_password']!;
  String get authInvalidEmail => _localizedValues[locale.languageCode]!['auth_invalid_email']!;
  String get authUserDisabled => _localizedValues[locale.languageCode]!['auth_user_disabled']!;
  String get authTooManyRequests => _localizedValues[locale.languageCode]!['auth_too_many_requests']!;
  String get authOperationNotAllowed => _localizedValues[locale.languageCode]!['auth_operation_not_allowed']!;
  String get authWeakPassword => _localizedValues[locale.languageCode]!['auth_weak_password']!;
  String get authEmailAlreadyInUse => _localizedValues[locale.languageCode]!['auth_email_already_in_use']!;
  String get authAccountExists => _localizedValues[locale.languageCode]!['auth_account_exists']!;
  String get authInvalidCredential => _localizedValues[locale.languageCode]!['auth_invalid_credential']!;
  String get authInvalidVerificationCode => _localizedValues[locale.languageCode]!['auth_invalid_verification_code']!;
  String get authInvalidVerificationId => _localizedValues[locale.languageCode]!['auth_invalid_verification_id']!;
  String get authGoogleSignInFailed => _localizedValues[locale.languageCode]!['auth_google_sign_in_failed']!;
  String get authNotAuthenticated => _localizedValues[locale.languageCode]!['auth_not_authenticated']!;
  String get networkError => _localizedValues[locale.languageCode]!['network_error']!;
  String get timeoutError => _localizedValues[locale.languageCode]!['timeout_error']!;
  String get serverError => _localizedValues[locale.languageCode]!['server_error']!;
  String get dataNotFound => _localizedValues[locale.languageCode]!['data_not_found']!;
  String get invalidData => _localizedValues[locale.languageCode]!['invalid_data']!;
  String get dataLoadError => _localizedValues[locale.languageCode]!['data_load_error']!;
  String get permissionDenied => _localizedValues[locale.languageCode]!['permission_denied']!;
  String get locationPermissionDenied => _localizedValues[locale.languageCode]!['location_permission_denied']!;
  String get cameraPermissionDenied => _localizedValues[locale.languageCode]!['camera_permission_denied']!;
  String get storageError => _localizedValues[locale.languageCode]!['storage_error']!;
  String get storageFull => _localizedValues[locale.languageCode]!['storage_full']!;
  String get invalidInput => _localizedValues[locale.languageCode]!['invalid_input']!;
  String get requiredField => _localizedValues[locale.languageCode]!['required_field']!;
  String get invalidFormat => _localizedValues[locale.languageCode]!['invalid_format']!;
  String get networkSuggestion => _localizedValues[locale.languageCode]!['network_suggestion']!;
  String get authSuggestion => _localizedValues[locale.languageCode]!['auth_suggestion']!;
  String get dataSuggestion => _localizedValues[locale.languageCode]!['data_suggestion']!;
}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();
  
  @override
  bool isSupported(Locale locale) {
    return ['en', 'es'].contains(locale.languageCode);
  }
  
  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }
  
  @override
  bool shouldReload(AppLocalizationsDelegate old) => false;
} 