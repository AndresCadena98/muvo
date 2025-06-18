part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class AuthCheckRequested extends AuthEvent {}

class SignInWithGoogleRequested extends AuthEvent {}

class SignOutRequested extends AuthEvent {}

class SignInWithEmailRequested extends AuthEvent {
  final String email;
  final String password;
  const SignInWithEmailRequested({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

class SignUpWithEmailRequested extends AuthEvent {
  final String email;
  final String password;
  const SignUpWithEmailRequested({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

class SendPasswordResetEmailRequested extends AuthEvent {
  final String email;
  const SendPasswordResetEmailRequested({required this.email});

  @override
  List<Object?> get props => [email];
} 