import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:puam_app/shared/index.dart';
import 'package:puam_app/user_profile/index.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBar(),
        body: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state is AuthStateLoggedIn) {
              return _buildProfilePage(context, state);
            } else {
              // If the user is not logged in, they should not be on this page
              // Redirect them to the login page or display a message
              WidgetsBinding.instance.addPostFrameCallback((_) {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => SignUpPage()),
                );
              });
              return SizedBox.shrink();
            }
          },
        ));
  }

  Column _buildProfilePage(BuildContext context, AuthStateLoggedIn state) {
    return Column(children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          IconButton(
            icon: Icon(Icons.settings),
            iconSize: 40,
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Settings()));
            },
          )
        ],
      ),
      Center(
          child: Icon(
        Icons.account_circle,
        size: 100,
      )),
      Container(
          padding: EdgeInsets.all(15),
          margin: EdgeInsets.all(15),
          child: Center(
              child: Text(
            state.user.email ?? "",
            style: AppTheme.username,
          ))),
      Container(
        padding: const EdgeInsets.only(left: 20),
        child: Align(
          alignment: AlignmentDirectional.centerStart,
          child: Text(
            'Favorites',
            style: Theme.of(context).textTheme.bodySmall,
            textAlign: TextAlign.start,
          ),
        ),
      ),
      const Divider(
        height: 10,
        thickness: 2,
        indent: 20,
        endIndent: 20,
        color: Colors.black,
      ),
      Column(mainAxisAlignment: MainAxisAlignment.end, children: [
        Text('Liked art will appear here!'),
      ])
    ]);
  }
}
