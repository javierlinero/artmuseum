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
  late ProfileRepo _repo;
  late AuthStateLoggedIn _currentState;

  @override
  void initState() {
    super.initState();
    _repo = ProfileRepo(
      getToken: () => _currentState.user.getIdToken(),
      favoritesService: FavoritesService(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          if (state is AuthStateLoggedIn) {
            _currentState = state; // Update the current state
            return _buildProfilePage(context, state);
          } else {
            return SizedBox.shrink();
          }
        },
      ),
    );
  }

  Column _buildProfilePage(BuildContext context, AuthStateLoggedIn state) {
    return Column(children: [
      Align(
        alignment: Alignment.topRight,
        child: IconButton(
          icon: Icon(Icons.settings),
          iconSize: 40,
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => Settings()));
          },
        ),
      ),
      Center(
      child: Icon(
        Icons.account_circle,
        size: 100,
      )),
      Container(
          padding: EdgeInsets.only(top:15, bottom: 20),
          child: Center(
              child: Text(
            state.user.displayName ?? state.user.email ?? "",
            style: AppTheme.username,
          ))),
      Container(
        padding: const EdgeInsets.only(bottom: 8),
        child: Align(
          alignment: AlignmentDirectional.center,
          child: Text(
            'Favorites',
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.start,
          ),
        ),
      ),
      const Divider(
        height: 0,
        thickness: 1,
        color: Colors.black,
      ),
      Expanded(
        child: FutureBuilder<List<Favorite>>(
          future: _repo.fetchFavorites(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator(); // Show a loader
            } else if (snapshot.hasError) {
              return Text("Error: ${snapshot.error}"); // Handle error
            } else if (snapshot.hasData) {
              List<Favorite> favorites = snapshot.data ?? [];
              if (favorites.isEmpty) {
                return Text(
                    'No favorites yet!'); // Show message if list is empty
              }
              return GridView.count(
                crossAxisCount: 3,
                children: List.generate(
                  favorites.length,
                  (index) {
                    return Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.black,
                          width: 1.0,
                        )
                      ),
                      child: GestureDetector(
                        onTap: () {
                          print("Tapped a Container");
                          Navigator.push(
                            context,MaterialPageRoute(builder: (context) => FavoritesDetailsPage(favorites[index].artWorkID)),);
                        },
                        behavior: HitTestBehavior.opaque,
                        child: ClipRect(
                          child: Image.network(
                            '${favorites[index].imageURL}/full/pct:5/0/default.jpg',
                            fit: BoxFit.cover,
                            loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Center(
                                child: CircularProgressIndicator (
                                  color: AppTheme.princetonOrange,
                                  value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes! : null,),
                              );
                            } ),
                          ),
                        ),
                    );
                  },
                ),
              );
            } else {
              return Text('No data'); // Handle no data case
            }
          },
        ),
      ),
    ]);
  }
}
