import 'package:puam_app/search/index.dart';

class SearchDetailRepo {
  final SearchDetailsService _searchService = SearchDetailsService();

  Future<SearchDetails> getSearchDetail(String artid) async {
    return await _searchService.fetchSearchDetail(artid);
  }
}
