import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:puam_app/auth/index.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final Auth _authService;

  AuthBloc(this._authService) : super(AuthStateInitial()) {
    on<AuthEventEmailSignUp>((event, emit) async {
      try {
        emit(AuthStateLoading());
        await _authService.createWithEmailAndPassword(
          email: event.email,
          password: event.password,
        );
        emit(AuthStateLoggedIn(_authService.currentUser!));
      } catch (e) {
        emit(AuthStateFailure(e.toString()));
      }
    });

    on<AuthEventEmailSignIn>((event, emit) async {
      try {
        emit(AuthStateLoading());
        await _authService.signInWithEmailAndPassword(
          email: event.email,
          password: event.password,
        );
        emit(AuthStateLoggedIn(_authService.currentUser!));
      } catch (e) {
        emit(AuthStateFailure(e.toString()));
      }
    });

    on<AuthEventGoogleSignIn>((event, emit) async {
      try {
        emit(AuthStateLoading());
        await _authService.signInWithGoogle();
        emit(AuthStateLoggedIn(_authService.currentUser!));
      } catch (e) {
        emit(AuthStateFailure(e.toString()));
      }
    });

    on<AuthEventSignOut>((event, emit) async {
      await _authService.signOut();
      emit(AuthStateLoggedOut());
    });
  }
}
