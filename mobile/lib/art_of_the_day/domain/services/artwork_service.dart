import 'package:dio/dio.dart';
import 'package:puam_app/art_of_the_day/index.dart';

class ArtworkService {
  final Dio _dio = Dio();

  final String serverUrl = "http://puamdns.ddns.net";

  Future<Artwork> fetchArtOfTheDay() async {
    try {
      Response response = await _dio.get('$serverUrl/art_of_the_day');
      var data = response.data;

      // If 'artists' in the JSON is null or empty, default to a list containing 'Unknown'
      List<String> artists =
          (data['artists'] != null && data['artists'].isNotEmpty)
              ? List<String>.from(data['artists'])
              : ['Unknown'];

      return Artwork(
        title: data['title'] ?? 'Unknown',
        artists: artists,
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
