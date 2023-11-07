abstract class AuthEvent {}

class AuthEventEmailSignIn extends AuthEvent {
  final String email;
  final String password;

  AuthEventEmailSignIn(this.email, this.password);
}

class AuthEventEmailSignUp extends AuthEvent {
  final String email;
  final String password;

  AuthEventEmailSignUp(this.email, this.password);
}

class AuthEventGoogleSignIn extends AuthEvent {}

class AuthEventSignOut extends AuthEvent {}
