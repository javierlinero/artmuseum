import 'package:dio/dio.dart';
import 'package:puam_app/user_profile/index.dart';

class FavoritesService {
  final Dio dio = Dio();
  final String serverUrl = "http://puamdns.ddns.net";

  Future<List<Favorite>> fetchFavorites(String? token) async {
    try {
      // Prepare headers
      Map<String, dynamic> headers = {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      };

      Response response = await dio.post(
        serverUrl,
        options: Options(headers: headers),
      );

      List<Favorite> favorites = (response.data as List)
          .map((item) => Favorite.fromJson(item))
          .toList();

      return favorites;
    } catch (error) {
      throw Exception('Failed to fetch artwork: $error');
    }
  }
}
