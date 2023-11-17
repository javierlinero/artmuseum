import 'package:dio/dio.dart';
import 'package:puam_app/tinder_for_art/index.dart';

class TinderService {
  Dio dio = Dio();
  String baseUrl = 'http://puamdns.ddns.net';

  Future<List<TinderArt>> tinderForArtGet(
      int numSuggestions, String? token) async {
    try {
      Response response = await dio.get(
        '$baseUrl/tinder_for_art',
        queryParameters: {'numart': numSuggestions},
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      List<dynamic> data = response.data;
      return data
          .map((item) => TinderArt(
                artworkId: item[0].toString(),
                imageUrl: item[1].toString(),
              ))
          .toList();
    } on DioException catch (e) {
      // Handle exception or return an empty list
      return [];
    }
  }

  Future<dynamic> tinderForArtPost(
      int artId, double rating, String? token) async {
    try {
      Response response = await dio.post(
        '$baseUrl/tinder_for_art',
        data: {'artid': artId, 'rating': rating},
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      return response.data;
    } on DioException catch (e) {
      return e;
    }
  }
}
