import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthState {}

class AuthStateInitial extends AuthState {}

class AuthStateLoading extends AuthState {}

class AuthStateLoggedIn extends AuthState {
  final User user;
  final String? token;
  final String? displayName;

  AuthStateLoggedIn(this.user, this.token, this.displayName);
}

class AuthStateLoggedOut extends AuthState {}

class AuthStateFailure extends AuthState {
  final FirebaseAuthException error;

  AuthStateFailure(this.error);
}
