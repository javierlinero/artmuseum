import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_launcher_icons/xml_templates.dart';
import 'package:puam_app/shared/index.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  double deviceHeight(BuildContext context) =>
      MediaQuery.of(context).size.height;
  double deviceWidth(BuildContext context) => MediaQuery.of(context).size.width;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      body: LayoutBuilder(
        builder: (context, constraints) {
            return Column (
              mainAxisAlignment: MainAxisAlignment.center,
              children: [ 
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [ 
                    Icon(
                      Icons.person_outline,
                      size: 200,)
                  ],
                ),
                Container(
                  height: constraints.maxHeight * 0.1,
                  child:Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                    ElevatedButton(
                      onPressed:() {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => UserCredentials())
                        );
                      },
                      style: FilledButton.styleFrom(
                        backgroundColor: AppTheme.princetonOrange
                      ),
                      child: Text(('Sign Up'), style: AppTheme.signUp),
                    ),
                    ElevatedButton(
                      onPressed:() {},
                      style: FilledButton.styleFrom(
                        backgroundColor: AppTheme.princetonOrange
                      ),
                      child: Text(('Login'), style: AppTheme.signUp),
                    )
                  ],
                  ),

                ),
               
              ],
            );
        }
            ),
          );
  }
}

class UserCredentials extends StatefulWidget {
  const UserCredentials({super.key});

  @override
  State<UserCredentials> createState() => _UserCredentialsState();
}

class _UserCredentialsState extends State<UserCredentials> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      body: Column(
        children: [
          ElevatedButton(
            onPressed:() {},
            style: FilledButton.styleFrom(
              backgroundColor: AppTheme.princetonOrange
            ),
            child: Text(('Continue with Google'), style: AppTheme.signUp),
          ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
          child: TextFormField(
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
            decoration: const InputDecoration(
              filled: true,
              fillColor: Colors.grey,
              border: UnderlineInputBorder(),
              labelText: 'Full Name',
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
          child: TextFormField(
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
            decoration: const InputDecoration(
              filled: true,
              fillColor: Colors.grey,
              border: UnderlineInputBorder(),
              labelText: 'Password',
            ),
          ),
        ),
        ElevatedButton(
            onPressed:() {},
            style: FilledButton.styleFrom(
              backgroundColor: AppTheme.princetonOrange
            ),
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
        ]
      ),
    );
  }
}