import 'package:flutter/material.dart';
import 'package:puam_app/shared/index.dart';


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
      body: Column(children: [
        Center(
          child: CircleAvatar(
          radius: 102, // Some padding for the border
          backgroundColor: Colors.black, // Or any color for the border
          child: CircleAvatar(
            radius: 100,
            backgroundColor: Colors.grey[200],
          ),
          )
        ),
        Center(
          child: Text('First Name Last Name', style: AppTheme.artworkDescription,)
        ),
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
        ] 
        )
      );
  }
}
