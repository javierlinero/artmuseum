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
  List<Favorite> _favorites = [];
  late ProfileRepo _repo;

  @override
  void initState() {
    super.initState();
    _repo = ProfileRepo(favoritesService: FavoritesService());
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    try {
      List<Favorite> favorites = await _repo.fetchFavorites();
      setState(() {
        _favorites = favorites;
      });
    } catch (e) {
      // Handle any errors here
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthStateLoggedIn) {
          return _buildProfilePage(context, state);
        } else
          return SizedBox.shrink();
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
            state.user.displayName ?? state.user.email ?? "",
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
      Text('Liked art will appear here!'), //message appears if no favorites
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
                crossAxisCount: 4,
                children: List.generate(
                  favorites.length,
                  (index) {
                    return Center(
                      child: Image.network(
                        '${favorites[index].imageURL}/full/pct:10/0/default.jpg',
                        fit: BoxFit.cover,
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
