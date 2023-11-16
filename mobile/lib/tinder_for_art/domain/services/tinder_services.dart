import 'package:dio/dio.dart';

class TinderService {
  Dio dio = Dio();
  String baseUrl = 'http://puamdns.ddns.net';

  Future<dynamic> tinderForArtGet(int numSuggestions, String? token) async {
    try {
      Response response = await dio.get(
        '$baseUrl/tinder_for_art',
        queryParameters: {'numart': numSuggestions},
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      return response.data;
    } on DioException catch (e) {
      return e;
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
