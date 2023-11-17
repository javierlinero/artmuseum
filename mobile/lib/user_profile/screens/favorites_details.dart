import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:puam_app/shared/index.dart';
import 'package:puam_app/user_profile/index.dart';


class FavoritesDetails extends StatelessWidget {
  final String imageURL; 

  FavoritesDetails(this.imageURL);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      body: Center(
        child: Image.network(
          '$imageURL/full/full/0/default.jpg', 
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}