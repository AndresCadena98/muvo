import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:muvo/core/error/app_exception.dart';
import 'package:muvo/core/services/language_service.dart';
import 'package:get_it/get_it.dart';
import 'package:muvo/features/auth/domain/repositories/auth_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;
  final FirebaseAuth _auth;
  final GoogleSignIn _googleSignIn;
  final LanguageService _languageService;
  StreamSubscription<User?>? _authStateSubscription;

  AuthBloc({
    required this.authRepository,
    FirebaseAuth? auth,
    GoogleSignIn? googleSignIn,
    LanguageService? languageService,
  })  : _auth = auth ?? FirebaseAuth.instance,
        _googleSignIn = googleSignIn ?? GoogleSignIn(),
        _languageService = languageService ?? GetIt.I<LanguageService>(),
        super(AuthInitial()) {
    on<AuthCheckRequested>(_onAuthCheckRequested);
    on<SignInWithGoogleRequested>(_onSignInWithGoogleRequested);
    on<SignOutRequested>(_onSignOutRequested);
    on<SignInWithEmailRequested>(_onSignInWithEmailRequested);
    on<SignUpWithEmailRequested>(_onSignUpWithEmailRequested);
    on<SendPasswordResetEmailRequested>(_onSendPasswordResetEmailRequested);

    // Escuchar cambios en el estado de autenticación
    _authStateSubscription = authRepository.authStateChanges.listen((User? user) {
      if (user != null) {
        add(AuthCheckRequested());
      } else {
        add(AuthCheckRequested());
      }
    });
  }

  @override
  Future<void> close() {
    _authStateSubscription?.cancel();
    return super.close();
  }

  Future<void> _onAuthCheckRequested(
    AuthCheckRequested event,
    Emitter<AuthState> emit,
  ) async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        emit(AuthAuthenticated(user: user));
      } else {
        emit(AuthUnauthenticated());
      }
    } catch (e) {
      emit(AuthError(AppException.unknownError(e)));
    }
  }

  Future<void> _onSignInWithGoogleRequested(
    SignInWithGoogleRequested event,
    Emitter<AuthState> emit,
  ) async {
    try {
      emit(AuthLoading());
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        emit(AuthUnauthenticated());
        return;
      }

      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _auth.signInWithCredential(credential);
      emit(AuthAuthenticated(user: userCredential.user!));
    } on FirebaseAuthException catch (e) {
      emit(AuthError(AppException.fromFirebaseAuthException(e)));
    } catch (e) {
      emit(AuthError(AppException.unknownError(e)));
    }
  }

  Future<void> _onSignOutRequested(
    SignOutRequested event,
    Emitter<AuthState> emit,
  ) async {
    try {
      emit(AuthLoading());
      await Future.wait([
        _auth.signOut(),
        _googleSignIn.signOut(),
      ]);
      emit(AuthUnauthenticated());
    } on FirebaseAuthException catch (e) {
      emit(AuthError(AppException.fromFirebaseAuthException(e)));
    } catch (e) {
      emit(AuthError(AppException.unknownError(e)));
    }
  }

  Future<void> _onSignInWithEmailRequested(
    SignInWithEmailRequested event,
    Emitter<AuthState> emit,
  ) async {
    try {
      emit(AuthLoading());
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: event.email,
        password: event.password,
      );
      emit(AuthAuthenticated(user: userCredential.user!));
    } on FirebaseAuthException catch (e) {
      emit(AuthError(AppException.fromFirebaseAuthException(e)));
    } catch (e) {
      emit(AuthError(AppException.unknownError(e)));
    }
  }

  Future<void> _onSignUpWithEmailRequested(
    SignUpWithEmailRequested event,
    Emitter<AuthState> emit,
  ) async {
    try {
      emit(AuthLoading());
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: event.email,
        password: event.password,
      );
      emit(AuthAuthenticated(user: userCredential.user!));
    } on FirebaseAuthException catch (e) {
      emit(AuthError(AppException.fromFirebaseAuthException(e)));
    } catch (e) {
      emit(AuthError(AppException.unknownError(e)));
    }
  }

  Future<void> _onSendPasswordResetEmailRequested(
    SendPasswordResetEmailRequested event,
    Emitter<AuthState> emit,
  ) async {
    try {
      await authRepository.sendPasswordResetEmail(event.email);
      emit(AuthUnauthenticated());
    } catch (e) {
      if (e is FirebaseAuthException) {
        emit(AuthError(AppException.fromFirebaseAuthException(e)));
      } else {
        emit(AuthError(AppException.unknownError(e)));
      }
    }
  }
}

class AuthError extends AuthState {
  final AppException exception;

  const AuthError(this.exception);

  @override
  List<Object?> get props => [exception];
} 