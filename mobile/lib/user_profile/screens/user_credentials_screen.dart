// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:puam_app/shared/index.dart';
import 'package:puam_app/user_profile/index.dart';

class UserCredentials extends StatefulWidget {
  const UserCredentials({super.key});

  @override
  State<UserCredentials> createState() => _UserCredentialsState();
}

class _UserCredentialsState extends State<UserCredentials> {
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();
  final TextEditingController _controllerDisplayName = TextEditingController();
  final TextEditingController _controllerConfirmPassword =
      TextEditingController();

  bool _isSignUpButtonEnabled = false;
  bool _emailValid = true;
  bool _isPasswordMatching = true;
  bool _isPasswordLongEnough = true;
  bool _isDisplayNameNotEmpty = true;

  void _onSubmit(BuildContext context) {
    BlocProvider.of<AuthBloc>(context).add(
      AuthEventEmailSignUp(
        _controllerEmail.text,
        _controllerPassword.text,
        _controllerDisplayName.text,
      ),
    );
    Navigator.pop(context);
  }

  bool _isEmailValid(String email) {
    Pattern pattern = r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+';
    RegExp regex = RegExp(pattern.toString());
    return regex.hasMatch(email);
  }

  void _validateForm() {
    bool isEmailValid = _isEmailValid(_controllerEmail.text);
    bool isPasswordMatching =
        _controllerPassword.text == _controllerConfirmPassword.text;
    bool isPasswordLongEnough = _controllerPassword.text.length >= 6;
    bool isDisplayNameNotEmpty = _controllerDisplayName.text.isNotEmpty;

    setState(() {
      _emailValid = isEmailValid;
      _isPasswordMatching = isPasswordMatching;
      _isPasswordLongEnough = isPasswordLongEnough;
      _isDisplayNameNotEmpty = isDisplayNameNotEmpty;
      _isSignUpButtonEnabled = isPasswordMatching &&
          isPasswordLongEnough &&
          isDisplayNameNotEmpty &&
          isEmailValid;
    });
  }

  @override
  void initState() {
    super.initState();
    _controllerPassword.addListener(_validateForm);
    _controllerConfirmPassword.addListener(_validateForm);
    _controllerDisplayName.addListener(_validateForm);
    _controllerEmail.addListener(_validateForm);
  }

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
          return Center(
              child: CircularProgressIndicator(
            color: AppTheme.princetonOrange,
          ));
        }
        return _buildUserCredentialsPage(context);
      }),
    );
  }

  Widget _buildUserCredentialsPage(BuildContext context) {
    const double errorTextHeight = 15;
    return SingleChildScrollView(
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Text(
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
        Container(
          margin: const EdgeInsets.all(15),
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
            cursorColor: AppTheme.princetonOrange.withOpacity(0.5),
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.grey,
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: AppTheme.princetonOrange),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: AppTheme.princetonOrange),
              ),
              labelText: 'Email Address',
              labelStyle: TextStyle(
                color: Colors.black.withOpacity(0.5),
              ),
              floatingLabelStyle: TextStyle(
                color: AppTheme.princetonOrange.withOpacity(0.75),
              ),
            ),
          ),
        ),
        SizedBox(
          height: errorTextHeight,
          child: _emailValid || _controllerEmail.text.isEmpty
              ? null
              : Text(
                  'Invalid email address',
                  style: TextStyle(color: Colors.red, fontSize: 12),
                ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
          child: TextFormField(
            controller: _controllerDisplayName,
            cursorColor: AppTheme.princetonOrange.withOpacity(0.5),
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.grey,
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: AppTheme.princetonOrange),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: AppTheme.princetonOrange),
              ),
              labelText: 'Display Name',
              labelStyle: TextStyle(
                color: Colors.black.withOpacity(0.5),
              ),
              floatingLabelStyle: TextStyle(
                color: AppTheme.princetonOrange.withOpacity(0.75),
              ),
            ),
          ),
        ),
        SizedBox(
          height: errorTextHeight,
          child: _isDisplayNameNotEmpty
              ? null
              : Text(
                  'Display name cannot be empty',
                  style: TextStyle(color: Colors.red, fontSize: 12),
                ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
          child: TextFormField(
            obscureText: true,
            controller: _controllerPassword,
            cursorColor: AppTheme.princetonOrange.withOpacity(0.5),
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.grey,
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: AppTheme.princetonOrange),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: AppTheme.princetonOrange),
              ),
              labelText: 'Password',
              labelStyle: TextStyle(
                color: Colors.black.withOpacity(0.5),
              ),
              floatingLabelStyle: TextStyle(
                color: AppTheme.princetonOrange.withOpacity(0.75),
              ),
            ),
          ),
        ),
        SizedBox(
          height: errorTextHeight,
          child: _isPasswordLongEnough
              ? null
              : Text(
                  'Password must be at least 6 characters long',
                  style: TextStyle(color: Colors.red, fontSize: 12),
                ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
          child: TextFormField(
            obscureText: true,
            controller: _controllerConfirmPassword,
            cursorColor: AppTheme.princetonOrange.withOpacity(0.5),
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.grey,
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: AppTheme.princetonOrange),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: AppTheme.princetonOrange),
              ),
              labelText: 'Re-type Password',
              labelStyle: TextStyle(
                color: Colors.black.withOpacity(0.5),
              ),
              floatingLabelStyle: TextStyle(
                color: AppTheme.princetonOrange.withOpacity(0.75),
              ),
            ),
          ),
        ),
        SizedBox(
          height: errorTextHeight,
          child: _isPasswordMatching || _controllerPassword.text.isEmpty
              ? null
              : Text(
                  'Passwords do not match',
                  style: TextStyle(color: Colors.red, fontSize: 12),
                ),
        ),
        ElevatedButton(
          onPressed: _isSignUpButtonEnabled
              ? () {
                  _onSubmit(context);
                  _controllerEmail.clear();
                  _controllerPassword.clear();
                  _controllerConfirmPassword.clear();
                }
              : null, // Disable if passwords don't match
          style: FilledButton.styleFrom(
            backgroundColor: _isSignUpButtonEnabled
                ? AppTheme.princetonOrange
                : Colors.grey, // Grey out if disabled
          ),
          child: Text('Sign Up', style: AppTheme.signUp),
        ),
      ]),
    );
  }

  @override
  void dispose() {
    _controllerEmail.removeListener(_validateForm);
    _controllerPassword.removeListener(_validateForm);
    _controllerDisplayName.removeListener(_validateForm);
    _controllerConfirmPassword.removeListener(_validateForm);
    _controllerEmail.dispose();
    _controllerPassword.dispose();
    _controllerDisplayName.dispose();
    _controllerConfirmPassword.dispose();
    super.dispose();
  }
}
