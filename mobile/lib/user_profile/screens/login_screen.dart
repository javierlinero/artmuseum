import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:puam_app/shared/index.dart';
import 'package:puam_app/user_profile/index.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

final TextEditingController _controllerEmail = TextEditingController();
final TextEditingController _controllerPassword = TextEditingController();

void _onSubmit(BuildContext context) {
  BlocProvider.of<AuthBloc>(context).(
    AuthEventEmailSignIn(
      _controllerEmail.text,
      _controllerPassword.text,
    ),
  );
  Navigator.pop(context);
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      body: BlocConsumer<AuthBloc, AuthState>(listener: ((context, state) {
        if (state is AuthStateFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error)),
          );
        }
      }), builder: (context, state) {
        if (state is AuthStateLoading) {
          return Center(child: CircularProgressIndicator());
        }
        return _buildLoginPage(context);
      }),
    );
  }

  Column _buildLoginPage(BuildContext context) {
    return Column(children: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
        child: TextFormField(
          controller: _controllerEmail,
          decoration: const InputDecoration(
            filled: true,
            fillColor: Colors.grey,
            border: UnderlineInputBorder(),
            labelText: 'Username',
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
        child: TextFormField(
          controller: _controllerPassword,
          decoration: const InputDecoration(
            filled: true,
            fillColor: Colors.grey,
            border: UnderlineInputBorder(),
            labelText: 'Password',
          ),
        ),
      ),
      ElevatedButton(
        onPressed: () {
          _onSubmit(context);
          _controllerEmail.clear();
          _controllerPassword.clear();
        },
        style:
            FilledButton.styleFrom(backgroundColor: AppTheme.princetonOrange),
        child: Text(('Log In'), style: AppTheme.signUp),
      ),
    ]);
  }
}
