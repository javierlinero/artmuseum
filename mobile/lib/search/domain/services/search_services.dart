import 'package:dio/dio.dart';

class SearchService {
  final Dio dio = Dio();
  final String baseurl = 'http://puamdns.ddns.net';

  Future<Response> fetchArtworks({String? query, int? year, int? limit}) async {
    try {
      return await dio.get('$baseurl/search', queryParameters: {
        'query': query,
        'year': year,
        'limit': limit,
      });
    } catch (e) {
      throw Exception('Failed to fetch artworks: ${e.toString()}');
    }
  }
}
