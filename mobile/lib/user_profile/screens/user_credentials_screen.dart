import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:puam_app/shared/index.dart';
import 'package:puam_app/user_profile/index.dart';

class UserCredentials extends StatefulWidget {
  const UserCredentials({super.key});

  @override
  State<UserCredentials> createState() => _UserCredentialsState();
}

class _UserCredentialsState extends State<UserCredentials> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();
  final TextEditingController _controllerDisplayName = TextEditingController();
  final TextEditingController _controllerConfirmPassword =
      TextEditingController();

  FToast fToast = FToast();

  void _onSubmit(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      final authBloc = BlocProvider.of<AuthBloc>(context);
      authBloc.add(
        AuthEventEmailSignUp(
          _controllerEmail.text,
          _controllerPassword.text,
          _controllerDisplayName.text,
        ),
      );
      authBloc.stream.listen((state) {
        if (state is AuthStateLoggedIn) {
          Navigator.pop(context);
        }
      });
    }
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    Pattern pattern = r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+';
    RegExp regex = RegExp(pattern.toString());
    if (!regex.hasMatch(value)) {
      return 'Invalid email address';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  String? _validateDisplayName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Display name is required';
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != _controllerPassword.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  Padding _buildTextFormFieldWithErrorMessage({
    required TextEditingController controller,
    required String labelText,
    required FormFieldValidator<String> validator,
    bool obscureText = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            controller: controller,
            obscureText: obscureText,
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
              labelText: labelText,
              labelStyle: TextStyle(
                color: Colors.black.withOpacity(0.5),
              ),
              floatingLabelStyle: TextStyle(
                color: AppTheme.princetonOrange.withOpacity(0.75),
              ),
            ),
            validator: validator,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: ((context, state) {
          if (state is AuthStateFailure) {
            debugPrint(state.error.code);
            if (state.error.code == 'email-already-in-use') {
              fToast.showToast(
                  gravity: ToastGravity.CENTER,
                  child: ErrorMessagePopup(error: 'Email already exists.'));
            } else {
              fToast.showToast(
                  gravity: ToastGravity.CENTER,
                  child: ErrorMessagePopup(error: state.error.code));
            }
          }
        }),
        builder: (context, state) {
          fToast.init(context);
          return SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Sign up to use exclusive features for free!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontFamily: 'Lato',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.all(15),
                      decoration: const ShapeDecoration(
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                              width: 1,
                              strokeAlign: BorderSide.strokeAlignCenter),
                        ),
                      ),
                    ),
                    _buildTextFormFieldWithErrorMessage(
                        controller: _controllerEmail,
                        labelText: 'Email',
                        validator: _validateEmail),
                    _buildTextFormFieldWithErrorMessage(
                        controller: _controllerDisplayName,
                        labelText: 'Display Name',
                        validator: _validateDisplayName),
                    _buildTextFormFieldWithErrorMessage(
                      controller: _controllerPassword,
                      labelText: 'Password',
                      validator: _validatePassword,
                      obscureText: true,
                    ),
                    _buildTextFormFieldWithErrorMessage(
                      controller: _controllerConfirmPassword,
                      labelText: 'Re-type Password',
                      validator: _validateConfirmPassword,
                      obscureText: true,
                    ),
                    ElevatedButton(
                      onPressed: () => _onSubmit(context),
                      style: FilledButton.styleFrom(
                        backgroundColor: AppTheme.princetonOrange,
                      ),
                      child: Text('Sign Up', style: AppTheme.signUp),
                    ),
                  ]),
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _controllerEmail.dispose();
    _controllerPassword.dispose();
    _controllerDisplayName.dispose();
    _controllerConfirmPassword.dispose();
    super.dispose();
  }
}
