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
