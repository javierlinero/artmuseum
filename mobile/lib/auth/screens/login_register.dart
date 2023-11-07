// ignore_for_file: must_be_immutable, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:puam_app/auth/index.dart';

class LoginRegisterPage extends StatelessWidget {
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();
  bool isLogin = true;

  LoginRegisterPage({super.key});

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
            height: double.infinity,
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextField(
                  controller: _controllerEmail,
                  decoration: InputDecoration(labelText: 'Email'),
                ),
                TextField(
                  controller: _controllerPassword,
                  obscureText: true,
                  decoration: InputDecoration(labelText: 'Password'),
                ),
                if (state is AuthStateFailure) ...[
                  Text('Error: ${state.error}'), // Show error message
                ],
                ElevatedButton(
                  onPressed: () {
                    if (isLogin) {
                      // Dispatch login event
                      BlocProvider.of<AuthBloc>(context).add(
                        AuthEventEmailSignIn(
                          _controllerEmail.text,
                          _controllerPassword.text,
                        ),
                      );
                    } else {
                      // Dispatch registration event
                    }
                  },
                  child: Text(isLogin ? 'Login' : 'Register'),
                ),
                TextButton(
                  onPressed: () {
                    // Toggle isLogin and refresh UI
                    isLogin = !isLogin;
                    (context as Element).markNeedsBuild();
                  },
                  child: Text(isLogin ? 'Register Instead' : 'Login Instead'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Dispatch Google sign-in event
                  },
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
