import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:muvo/features/auth/domain/repositories/auth_repository.dart';
import 'package:flutter/foundation.dart';

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;
  static const String _userSessionKey = 'user_session';

  AuthRepositoryImpl({
    FirebaseAuth? firebaseAuth,
    GoogleSignIn? googleSignIn,
  })  : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _googleSignIn = googleSignIn ?? GoogleSignIn() {
    debugPrint('AuthRepositoryImpl: Inicializado con Firebase Auth y Google Sign In');
  }

  @override
  Future<UserCredential> signInWithGoogle() async {
    try {
      debugPrint('Google Sign In: Iniciando proceso de autenticación');
      debugPrint('Google Sign In: Estado actual de Firebase Auth: ${_firebaseAuth.currentUser?.email}');
      
      // Primero, intentar cerrar sesión de Google para evitar problemas de caché
      await _googleSignIn.signOut();
      debugPrint('Google Sign In: Sesión anterior cerrada');
      
      // Iniciar el proceso de inicio de sesión con Google
      debugPrint('Google Sign In: Solicitando selección de cuenta de Google');
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      debugPrint('Google Sign In: Usuario seleccionado: ${googleUser?.email}');
      
      if (googleUser == null) {
        debugPrint('Google Sign In: Usuario canceló el proceso de selección de cuenta');
        throw Exception('El inicio de sesión con Google fue cancelado por el usuario');
      }

      try {
        debugPrint('Google Sign In: Obteniendo tokens de autenticación');
        final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
        debugPrint('Google Sign In: Tokens obtenidos - Access Token: ${googleAuth.accessToken != null}, ID Token: ${googleAuth.idToken != null}');
        
        if (googleAuth.accessToken == null || googleAuth.idToken == null) {
          debugPrint('Google Sign In: Error - Tokens nulos');
          throw Exception('No se pudieron obtener los tokens de autenticación de Google');
        }

        debugPrint('Google Sign In: Creando credencial de Firebase');
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        debugPrint('Google Sign In: Intentando autenticar con Firebase');
        final userCredential = await _firebaseAuth.signInWithCredential(credential);
        debugPrint('Google Sign In: Usuario autenticado en Firebase: ${userCredential.user?.email}');
        
        if (userCredential.user == null) {
          debugPrint('Google Sign In: Error - Usuario nulo después de autenticación');
          throw Exception('No se pudo obtener el usuario después de la autenticación');
        }

        debugPrint('Google Sign In: Guardando sesión de usuario');
        await saveUserSession(userCredential.user!);
        debugPrint('Google Sign In: Proceso completado exitosamente');
        return userCredential;
      } catch (e) {
        debugPrint('Google Sign In Error durante la autenticación: $e');
        debugPrint('Google Sign In Stack trace: ${StackTrace.current}');
        // Si hay un error durante la autenticación, asegurarse de cerrar sesión
        await _googleSignIn.signOut();
        throw Exception('Error durante la autenticación con Google: $e');
      }
    } catch (e) {
      debugPrint('Google Sign In Error general: $e');
      debugPrint('Google Sign In Stack trace: ${StackTrace.current}');
      // Manejar errores específicos
      if (e is FirebaseAuthException) {
        debugPrint('Google Sign In FirebaseAuthException: ${e.code} - ${e.message}');
        debugPrint('Google Sign In FirebaseAuthException Stack trace: ${e.stackTrace}');
        switch (e.code) {
          case 'account-exists-with-different-credential':
            throw Exception('Ya existe una cuenta con el mismo correo electrónico pero con diferentes credenciales');
          case 'invalid-credential':
            throw Exception('Las credenciales de Google no son válidas');
          case 'operation-not-allowed':
            throw Exception('El inicio de sesión con Google no está habilitado');
          case 'user-disabled':
            throw Exception('La cuenta de usuario ha sido deshabilitada');
          case 'user-not-found':
            throw Exception('No se encontró la cuenta de usuario');
          case 'wrong-password':
            throw Exception('Contraseña incorrecta');
          case 'invalid-verification-code':
            throw Exception('Código de verificación inválido');
          case 'invalid-verification-id':
            throw Exception('ID de verificación inválido');
          default:
            throw Exception('Error de autenticación: ${e.message}');
        }
      }
      throw Exception('Error al iniciar sesión con Google: $e');
    }
  }

  @override
  Future<void> signOut() async {
    await Future.wait([
      _firebaseAuth.signOut(),
      _googleSignIn.signOut(),
      clearUserSession(),
    ]);
  }

  @override
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  @override
  User? get currentUser => _firebaseAuth.currentUser;

  @override
  Future<bool> isUserLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_userSessionKey) ?? false;
  }

  @override
  Future<void> saveUserSession(User user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_userSessionKey, true);
  }

  @override
  Future<void> clearUserSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userSessionKey);
  }

  @override
  Future<UserCredential> signInWithEmail(String email, String password) async {
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      if (userCredential.user != null) {
        await saveUserSession(userCredential.user!);
      }
      return userCredential;
    } catch (e) {
      throw Exception('Error al iniciar sesión con email: $e');
    }
  }

  @override
  Future<UserCredential> signUpWithEmail(String email, String password) async {
    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
      if (userCredential.user != null) {
        await saveUserSession(userCredential.user!);
      }
      return userCredential;
    } catch (e) {
      throw Exception('Error al registrarse con email: $e');
    }
  }

  @override
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } catch (e) {
      throw Exception('Error al enviar email de recuperación: $e');
    }
  }
} 