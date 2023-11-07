import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:puam_app/auth/auth.dart';

class LoginRegisterPage extends StatefulWidget{
  const LoginRegisterPage({Key? key}) : super(key: key);

  @override
  State<LoginRegisterPage> createState() => _LoginRegisterPageState();

}

class _LoginRegisterPageState extends State<LoginRegisterPage> {
  String? errorMessage = '';
  bool isLogin = true;

  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();

  Future<void> signInWithEmailAndPassword() async {
    try{
      await Auth().signInWithEmailAndPassword(email: _controllerEmail.text, password: _controllerPassword.text);
    } on FirebaseAuthException catch (e) {
      setState(() {
      errorMessage = e.message;
    });
    }
  }

  Future<void> createWithEmailAndPassword() async {
    try{
      await Auth().createWithEmailAndPassword(email: _controllerEmail.text, password: _controllerPassword.text);
    } on FirebaseAuthException catch (e) {
      setState(() {
      errorMessage = e.message;
    });
    }
  }

  Widget _title() {
    return const Text('PUAM Authentication');
  }

  Widget _entryField(
    String title,
    TextEditingController controller,
  ) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: title
      ),
    );
  }

  Widget _errorMessage() {
    return Text(errorMessage == '' ? '' : 'Humm ? $errorMessage');
  }

  Widget _submitButton() {
    return ElevatedButton(
      onPressed: 
        isLogin ? signInWithEmailAndPassword : createWithEmailAndPassword, 
      child: Text(isLogin ? 'Login' : 'Register'));
  }

  Widget _loginOrRegistrationButton() {
    return TextButton(onPressed: () {
      setState(() {
        isLogin = !isLogin;
      });
    }, child: Text(isLogin ? 'Register Instead' : 'Login Instead'));
  }

  Widget _authGoogle() {
    return ElevatedButton(onPressed: Auth().signInWithGoogle, child: const Text('Sign In With Google'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: _title()),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _entryField('email', _controllerEmail),
            _entryField('password', _controllerPassword),
            _errorMessage(),
            _submitButton(),
            _loginOrRegistrationButton(),
            _authGoogle(),
          ],
        ),
      )
    );
  }

}

