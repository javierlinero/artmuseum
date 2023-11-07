// ignore_for_file: must_be_immutable, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:puam_app/auth/index.dart';

class LoginRegisterPage extends StatelessWidget {
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();
  bool isLogin = true;

  LoginRegisterPage({super.key});

  void _onSubmit(BuildContext context) {
    if (isLogin) {
      BlocProvider.of<AuthBloc>(context).add(
        AuthEventEmailSignIn(
          _controllerEmail.text,
          _controllerPassword.text,
        ),
      );
    } else {
      BlocProvider.of<AuthBloc>(context).add(
        AuthEventEmailSignUp(
          _controllerEmail.text,
          _controllerPassword.text,
        ),
      );
    }
  }

  void _onGoogleSignIn(BuildContext context) {
    BlocProvider.of<AuthBloc>(context).add(AuthEventGoogleSignIn());
  }

  void _toggleForm(BuildContext context) {
    isLogin = !isLogin;
    (context as Element).markNeedsBuild();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(isLogin ? 'Login' : 'Register')),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthStateFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error)),
            );
          } else if (state is AuthStateLoggedIn) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => LoginPage()),
            );
          }
        },
        builder: (context, state) {
          if (state is AuthStateLoading) {
            return Center(child: CircularProgressIndicator());
          }
          return Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                  controller: _controllerEmail,
                  decoration: InputDecoration(labelText: 'Email'),
                ),
                TextField(
                  controller: _controllerPassword,
                  obscureText: true,
                  decoration: InputDecoration(labelText: 'Password'),
                ),
                if (state is AuthStateFailure) Text('Error: ${state.error}'),
                ElevatedButton(
                  onPressed: () => _onSubmit(context),
                  child: Text(isLogin ? 'Login' : 'Register'),
                ),
                TextButton(
                  onPressed: () => _toggleForm(context),
                  child: Text(isLogin ? 'Register Instead' : 'Login Instead'),
                ),
                ElevatedButton(
                  onPressed: () => _onGoogleSignIn(context),
                  child: const Text('Sign In With Google'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
