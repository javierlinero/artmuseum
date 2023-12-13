import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:puam_app/shared/index.dart';
import 'package:puam_app/user_profile/index.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
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

class _LoginState extends State<Login> {
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final FToast ftoast = FToast();
  void _onSubmit(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      final authBloc = BlocProvider.of<AuthBloc>(context);
      authBloc.add(
        AuthEventEmailSignIn(
          _controllerEmail.text,
          _controllerPassword.text,
        ),
      );
      authBloc.stream.listen((state) {
        if (state is AuthStateLoggedIn) {
          Navigator.pop(context);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      body: BlocConsumer<AuthBloc, AuthState>(listener: ((context, state) {
        ftoast.init(context);
        if (state is AuthStateFailure) {
          debugPrint(state.error.code);
          if (state.error.code == 'invalid-credential') {
            ftoast.showToast(
                gravity: ToastGravity.CENTER,
                child: ErrorMessagePopup(error: 'Incorrect email or password'));
          } else if (state.error.code == 'too-many-requests') {
            ftoast.showToast(
                gravity: ToastGravity.CENTER,
                child: ErrorMessagePopup(error: 'Too many requests sent.'));
          } else {
            ftoast.showToast(
                gravity: ToastGravity.CENTER,
                child: ErrorMessagePopup(error: state.error.code));
          }
        }
      }), builder: (context, state) {
        return _buildLoginPage(context);
      }),
    );
  }

  Widget _buildLoginPage(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(children: [
        _buildTextFormFieldWithErrorMessage(
            controller: _controllerEmail,
            labelText: 'Email',
            validator: _validateEmail),
        _buildTextFormFieldWithErrorMessage(
            controller: _controllerPassword,
            labelText: 'Password',
            validator: _validatePassword,
            obscureText: true),
        ElevatedButton(
          onPressed: () {
            _onSubmit(context);
          },
          style:
              FilledButton.styleFrom(backgroundColor: AppTheme.princetonOrange),
          child: Text(('Log In'), style: AppTheme.signUp),
        ),
      ]),
    );
  }

  @override
  void dispose() {
    _controllerEmail.dispose();
    _controllerPassword.dispose();
    super.dispose();
  }
}
