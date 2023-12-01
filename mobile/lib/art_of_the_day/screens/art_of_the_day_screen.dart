import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:puam_app/art_of_the_day/index.dart';
import 'package:puam_app/shared/index.dart';
import 'package:puam_app/user_profile/index.dart';

class ArtOfTheDayPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, authState) {
          // If the user logs out, we trigger a state change in ArtBloc
          if (authState is AuthStateLoggedOut) {
            context.read<ArtBloc>().add(FetchArtOfTheDayEvent());
          }
        },
        builder: (context, authState) {
          if (authState is AuthStateLoggedIn) {
            // User is logged in
            return ArtOfTheDayContent(authState.token);
          } else {
            // User is not logged in or has logged out
            return ArtOfTheDayDefault();
          }
        },
      ),
    );
  }
}
