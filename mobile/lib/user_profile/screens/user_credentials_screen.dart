
import 'package:flutter/material.dart';
import 'package:puam_app/shared/index.dart';


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
      body: Column(children: [
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
              labelText: 'User Name',
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
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
          child: TextFormField(
            decoration: const InputDecoration(
              filled: true,
              fillColor: Colors.grey,
              border: UnderlineInputBorder(),
              labelText: 'Confirm Password',
            ),
          ),
        ),
        ElevatedButton(
          onPressed: () {},
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
      ]),
    );
  }
}
