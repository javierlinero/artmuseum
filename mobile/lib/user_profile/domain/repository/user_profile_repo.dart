import 'package:puam_app/user_profile/index.dart';

class ProfileRepo {
  final String? token;
  final FavoritesService _favoritesService;

  ProfileRepo({this.token, required FavoritesService favoritesService})
      : _favoritesService = favoritesService;

  Future<List<Favorite>> fetchFavorites() async {
    return await _favoritesService.fetchFavorites(token);
  }
}
