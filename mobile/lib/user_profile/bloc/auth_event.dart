import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthEvent {}

class AuthEventInitialize extends AuthEvent {}

class AuthEventEmailSignIn extends AuthEvent {
  final String email;
  final String password;

  AuthEventEmailSignIn(this.email, this.password);
}

class AuthEventEmailSignUp extends AuthEvent {
  final String email;
  final String password;
  final String displayName;

  AuthEventEmailSignUp(this.email, this.password, this.displayName);
}

class AuthEventGoogleSignIn extends AuthEvent {}

class AuthEventSignOut extends AuthEvent {}

class AuthEventUserChanged extends AuthEvent {
  final User user;

  AuthEventUserChanged(this.user);
}

class AuthEventUserNotFound extends AuthEvent {}
