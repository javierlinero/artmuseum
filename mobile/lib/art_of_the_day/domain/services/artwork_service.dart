import 'package:dio/dio.dart';
import 'package:puam_app/art_of_the_day/index.dart';

class ArtworkService {
  final Dio _dio = Dio();

  final String serverUrl = "http://127.0.0.1:8080";

  Future<Artwork> fetchArtOfTheDay() async {
    try {
      Response response = await _dio.get('$serverUrl/art_of_the_day');
      var data = response.data;

      String artist = (data['artists'] != null && data['artists'].isNotEmpty)
          ? data['artists'][0]
          : 'Unknown';

      return Artwork(
        title: data['title'] ?? 'Unknown',
        artist: artist,
        imageUrl: data['imageurl'],
        year: data['year'] ?? 'Unknown',
        materials: data['materials'] ?? 'Unknown',
        size: data['size'] ?? 'Unknown',
        description: data['description'] ?? 'Unknown',
      );
    } catch (error) {
      throw Exception('Failed to fetch artwork: $error');
    }
  }
}
