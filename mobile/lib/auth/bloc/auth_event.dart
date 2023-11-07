abstract class AuthEvent {}

class AuthEventEmailSignIn extends AuthEvent {
  final String email;
  final String password;

  AuthEventEmailSignIn(this.email, this.password);
}

class AuthEventSignOut extends AuthEvent {}
