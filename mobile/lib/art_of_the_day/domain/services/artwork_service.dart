import 'package:dio/dio.dart';
import 'package:puam_app/art_of_the_day/index.dart';

class ArtworkService {
  final Dio _dio = Dio();

  final String serverUrl = "http://127.0.0.1:8080";

  Future<Artwork> fetchArtOfTheDay() async {
    try {
      Response response = await _dio.get('$serverUrl/art-of-the-day');
      var data = response.data;
      return Artwork(
        title: data['title'],
        artist: data['artist'],
        imageUrl: data['imageUrl'],
        year: data['year'],
        materials: data['materials'],
        size: data['size'],
        description: data['description'],
      );
    } catch (error) {
      throw Exception('Failed to fetch artwork: $error');
    }
  }
}
