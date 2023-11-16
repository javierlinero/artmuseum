import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
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
      Response response = await dio.get(
        '$serverUrl/user_favorites',
        options: Options(headers: headers),
      );

      List<Favorite> favorites = parseJson(response.data);

      return favorites;
    } catch (error) {
      debugPrint('$error');
      return [];
    }
  }
}
