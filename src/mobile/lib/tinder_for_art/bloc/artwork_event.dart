import 'package:puam_app/tinder_for_art/index.dart';

abstract class ArtworkEvent {}

class UpdateArtworkIndex extends ArtworkEvent {
  final int index;

  UpdateArtworkIndex(this.index);
}

class ToggleUndo extends ArtworkEvent {
  final bool canUndo;

  ToggleUndo(this.canUndo);
}

class FetchArtworkRecommendations extends ArtworkEvent {
  final int numSuggestions;
  final String? token;

  FetchArtworkRecommendations(this.numSuggestions, this.token);
}

class SaveArtworks extends ArtworkEvent {
  final List<TinderArt> artworks;

  SaveArtworks(this.artworks);
}

class LoadSavedArtworks extends ArtworkEvent {
  final List<TinderArt> localArtworks;
  LoadSavedArtworks(this.localArtworks);
}
