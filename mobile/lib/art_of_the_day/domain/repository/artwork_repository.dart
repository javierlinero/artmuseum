import 'package:puam_app/art_of_the_day/index.dart';

class ArtworkRepository {
  final ArtworkService _artworkService = ArtworkService();

  Future<Artwork> getArtOfTheDay(String? token) async {
    return await _artworkService.fetchArtOfTheDay(authToken: token);
  }
}
