import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:puam_app/auth/index.dart';

class LoginPage extends StatelessWidget {
  LoginPage({Key? key}) : super(key: key);

  Widget _title() {
    return const Text('PUAM LOGIN');
  }

  Widget _userId(String email) {
    return Text(email);
  }

  Widget _signOutButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () =>
          BlocProvider.of<AuthBloc>(context).add(AuthEventSignOut()),
      child: const Text('Sign Out'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: _title()),
      body: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          if (state is AuthStateLoggedIn) {
            return Container(
              height: double.infinity,
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  _userId(state.user.email ?? 'No email available'),
                  _signOutButton(context),
                ],
              ),
            );
          } else {
            // If the user is not logged in, they should not be on this page
            // Redirect them to the login page or display a message
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => LoginRegisterPage()),
              );
            });
            return SizedBox.shrink(); // Temporary placeholder widget
          }
        },
      ),
    );
  }
}
