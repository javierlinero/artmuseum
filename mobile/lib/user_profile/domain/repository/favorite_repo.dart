import 'package:puam_app/user_profile/index.dart';

class FavoriteRepo {
  final FavoritesDetailsService _favoriteService = FavoritesDetailsService();

  Future<FavoritesDetails> getFavorite(String artid) async {
    return await _favoriteService.fetchFavorite(artid);
  }
}
