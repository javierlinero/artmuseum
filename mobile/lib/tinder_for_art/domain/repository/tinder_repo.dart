import 'package:puam_app/tinder_for_art/domain/index.dart';

class TinderForArtRepository {
  final TinderService _tinderService = TinderService();
  final String? token;

  TinderForArtRepository({required this.token});

  Future<dynamic> getArtSuggestions(int numSuggestions, String? token) async {
    return await _tinderService.tinderForArtGet(numSuggestions, token);
  }

  Future<dynamic> postArtRating(int artId, double rating, String? token) async {
    return await _tinderService.tinderForArtPost(artId, rating, token);
  }
}
