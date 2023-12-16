import 'package:puam_app/user_profile/index.dart';

class ProfileRepo {
  final Future<String?> Function()? getToken;
  final FavoritesService _favoritesService;

  ProfileRepo({this.getToken, required FavoritesService favoritesService})
      : _favoritesService = favoritesService;

  Future<List<Favorite>> fetchFavorites() async {
    String? token = await getToken!();
    return await _favoritesService.fetchFavorites(token);
  }
}
