import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  AuthBloc() : super(AuthStateInitial()) {
    on<AuthEventEmailSignIn>((event, emit) async {
      emit(AuthStateLoading());
      try {
        await _firebaseAuth.signInWithEmailAndPassword(
          email: event.email,
          password: event.password,
        );
        final User user = _firebaseAuth.currentUser!;
        emit(AuthStateLoggedIn(user));
      } catch (e) {
        emit(AuthStateFailure(e.toString()));
      }
    });

    on<AuthEventSignOut>((event, emit) async {
      await _firebaseAuth.signOut();
      emit(AuthStateLoggedOut());
    });
  }
}
