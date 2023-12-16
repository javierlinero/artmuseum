import 'package:flutter/material.dart';
import 'package:puam_app/shared/index.dart';
import 'package:puam_app/user_profile/index.dart';

class LoggedOutScreen extends StatelessWidget {
  const LoggedOutScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      body: LayoutBuilder(builder: (context, constraints) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.person_outline,
                  size: 200,
                )
              ],
            ),
            Container(
              height: constraints.maxHeight * 0.1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => UserCredentials()));
                    },
                    style: FilledButton.styleFrom(
                        backgroundColor: AppTheme.princetonOrange),
                    child: Text(('Sign Up'), style: AppTheme.signUp),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Login()));
                    },
                    style: FilledButton.styleFrom(
                        backgroundColor: AppTheme.princetonOrange),
                    child: Text(('Login'), style: AppTheme.signUp),
                  )
                ],
              ),
            ),
          ],
        );
      }),
    );
  }
}
