import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:puam_app/shared/index.dart';
import 'package:puam_app/user_profile/index.dart';

class UserCredentials extends StatefulWidget {
  const UserCredentials({super.key});

  @override
  State<UserCredentials> createState() => _UserCredentialsState();
}

final TextEditingController _controllerEmail = TextEditingController();
final TextEditingController _controllerPassword = TextEditingController();
final TextEditingController _controllerDisplayName = TextEditingController();

void _onSubmit(BuildContext context) {
  BlocProvider.of<AuthBloc>(context).add(
    AuthEventEmailSignUp(
      _controllerEmail.text,
      _controllerPassword.text,
      _controllerDisplayName.text,
    ),
  );
}

class _UserCredentialsState extends State<UserCredentials> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      body: BlocConsumer<AuthBloc, AuthState>(listener: ((context, state) {
        if (state is AuthStateFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error)),
          );
        } else if (state is AuthStateLoggedIn) {
          Navigator.pop(context);
        }
      }), builder: (context, state) {
        if (state is AuthStateLoading) {
          return Center(child: CircularProgressIndicator());
        }
        return _buildUserCredentialsPage(context);
      }),
    );
  }

  Column _buildUserCredentialsPage(BuildContext context) {
    return Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
      const SizedBox(
        width: 339.91,
        height: 61.63,
        child: Text(
          'Sign up to use exclusive features for free!',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontFamily: 'Lato',
            fontWeight: FontWeight.w500,
            height: 0,
          ),
        ),
      ),
      ElevatedButton(
        onPressed: () {},
        style:
            FilledButton.styleFrom(backgroundColor: AppTheme.princetonOrange),
        child: Text(('Continue with Google'), style: AppTheme.signUp),
      ),
      Container(
        margin: const EdgeInsets.all(15),
        width: .90 * MediaQuery.of(context).size.width,
        decoration: const ShapeDecoration(
          shape: RoundedRectangleBorder(
            side: BorderSide(
              width: 1,
              strokeAlign: BorderSide.strokeAlignCenter,
            ),
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
        child: TextFormField(
          controller: _controllerEmail,
          decoration: const InputDecoration(
            filled: true,
            fillColor: Colors.grey,
            border: UnderlineInputBorder(),
            labelText: 'E-Mail Address',
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
        child: TextFormField(
          controller: _controllerDisplayName,
          decoration: const InputDecoration(
            filled: true,
            fillColor: Colors.grey,
            border: UnderlineInputBorder(),
            labelText: 'Display Name',
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
      // Padding(
      //   padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      //   child: TextFormField(
      //     decoration: const InputDecoration(
      //       filled: true,
      //       fillColor: Colors.grey,
      //       border: UnderlineInputBorder(),
      //       labelText: 'Confirm Password',
      //     ),
      //   ),
      // ),
      ElevatedButton(
        onPressed: () {
          _onSubmit(context);
          _controllerEmail.clear();
          _controllerPassword.clear();
        },
        style:
            FilledButton.styleFrom(backgroundColor: AppTheme.princetonOrange),
        child: Text(('Sign Up'), style: AppTheme.signUp),
      ),
      const SizedBox(
        width: 351,
        height: 90,
        child: Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: 'By signing up, you agree to our ',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 24,
                  fontFamily: 'Lato',
                  fontWeight: FontWeight.w400,
                  height: 0,
                ),
              ),
              TextSpan(
                text: 'Terms, Data Policy ',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 24,
                  fontFamily: 'Lato',
                  fontWeight: FontWeight.w700,
                  height: 0,
                ),
              ),
              TextSpan(
                text: 'and ',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 24,
                  fontFamily: 'Lato',
                  fontWeight: FontWeight.w400,
                  height: 0,
                ),
              ),
              TextSpan(
                text: 'Cookies Policy.',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 24,
                  fontFamily: 'Lato',
                  fontWeight: FontWeight.w700,
                  height: 0,
                ),
              ),
            ],
          ),
          textAlign: TextAlign.center,
        ),
      )
    ]);
  }
}
