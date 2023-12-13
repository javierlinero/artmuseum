import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:puam_app/tinder_for_art/index.dart';
import 'package:puam_app/user_profile/index.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthService _authService;

  AuthBloc(this._authService) : super(AuthStateInitial()) {
    on<AuthEventInitialize>(_onInitialize);
    on<AuthEventUserChanged>(_onUserChanged);
    on<AuthEventUserNotFound>(_onUserNotFound);
    on<AuthEventEmailSignUp>((event, emit) async {
      try {
        emit(AuthStateLoading());
        await _authService.createWithEmailAndPassword(
          email: event.email,
          password: event.password,
          displayName: event.displayName,
        );
        emit(AuthStateLoggedIn(
            _authService.currentUser!,
            await _authService.getUserToken(),
            await _authService.getUserDisplayName()));
      } on FirebaseAuthException catch (e) {
        emit(AuthStateFailure(e));
      }
    });

    on<AuthEventEmailSignIn>((event, emit) async {
      try {
        emit(AuthStateLoading());
        await _authService.signInWithEmailAndPassword(
          email: event.email,
          password: event.password,
        );
        emit(AuthStateLoggedIn(
            _authService.currentUser!,
            await _authService.getUserToken(),
            await _authService.getUserDisplayName()));
      } on FirebaseAuthException catch (e) {
        emit(AuthStateFailure(e));
      }
    });

    on<AuthEventGoogleSignIn>((event, emit) async {
      try {
        emit(AuthStateLoading());
        await _authService.signInWithGoogle();
        emit(AuthStateLoggedIn(
            _authService.currentUser!,
            await _authService.getUserToken(),
            await _authService.getUserDisplayName()));
      } on FirebaseAuthException catch (e) {
        emit(AuthStateFailure(e));
      }
    });

    on<AuthEventSignOut>((event, emit) async {
      await _authService.signOut();
      await LocalStorageHelper.clearArtworks();
      emit(AuthStateLoggedOut());
    });

    // Listen to the auth state changes
    _authService.authStateChanges.listen((User? user) {
      if (user == null) {
        add(AuthEventUserNotFound());
      } else {
        add(AuthEventUserChanged(user));
      }
    });
  }

  void _onUserChanged(
      AuthEventUserChanged event, Emitter<AuthState> emit) async {
    emit(AuthStateLoggedIn(event.user, await _authService.getUserToken(),
        await _authService.getUserDisplayName()));
  }

  // Event handler for user not found
  void _onUserNotFound(AuthEventUserNotFound event, Emitter<AuthState> emit) {
    emit(AuthStateLoggedOut());
  }

  void _onInitialize(AuthEventInitialize event, Emitter<AuthState> emit) async {
    final currentUser = _authService.currentUser;
    if (currentUser != null) {
      emit(AuthStateLoggedIn(currentUser, await _authService.getUserToken(),
          await _authService.getUserDisplayName()));
    } else {
      emit(AuthStateLoggedOut());
    }
  }
}
