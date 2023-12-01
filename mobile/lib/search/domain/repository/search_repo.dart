import 'package:puam_app/search/index.dart';

class SearchRepo {
  final SearchService service;

  SearchRepo(this.service);

  Future<List<SearchArtwork>> searchArtworks(String query,
      {int? limit, int? offset}) async {
    return await service.fetchArtworks(
        query: query, limit: limit, offset: offset);
  }
}
