import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthState {}

class AuthStateInitial extends AuthState {}

class AuthStateLoading extends AuthState {}

class AuthStateLoggedIn extends AuthState {
  final User user;

  AuthStateLoggedIn(this.user);
}

class AuthStateLoggedOut extends AuthState {}

class AuthStateFailure extends AuthState {
  final String error;

  AuthStateFailure(this.error);
}
