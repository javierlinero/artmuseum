import 'package:puam_app/search/index.dart';

class SearchRepo {
  final SearchService service;

  SearchRepo(this.service);

  Future<List<SearchArtwork>> searchArtworks(String query, {int? limit}) async {
    final response = await service.fetchArtworks(query: query, limit: limit);
    List<SearchArtwork> artworks = (response.data as List)
        .map((item) => SearchArtwork.fromJson(item))
        .toList();
    return artworks;
  }
}
