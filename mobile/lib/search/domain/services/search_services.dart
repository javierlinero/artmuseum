import 'package:dio/dio.dart';
import 'package:puam_app/search/index.dart';

class SearchService {
  Dio dio = Dio()
    ..options = BaseOptions(
      baseUrl: 'http://puamdns.ddns.net:8080',
      connectTimeout: Duration(seconds: 50),
      receiveTimeout: Duration(seconds: 30),
    )
    ..interceptors.add(LogInterceptor(responseBody: true)); // Enable Logging
  final String baseurl = 'http://puamdns.ddns.net:8080';

  Future<List<SearchArtwork>> fetchArtworks(
      {String? query, int? year, int? limit, int? offset}) async {
    try {
      var response = await dio.get(
        '/search',
        data: {
          'query': query,
          'year': year,
          'limit': limit,
          'offset': offset,
        },
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
        ),
      );
      if (response.data is List) {
        return (response.data as List)
            .map((list) => SearchArtwork.fromList(list))
            .toList();
      } else {
        throw Exception('Invalid response format');
      }
    } catch (e) {
      throw Exception('Failed to fetch artworks: ${e.toString()}');
    }
  }
}