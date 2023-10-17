abstract class ArtworkEvent {}

class UpdateArtworkIndex extends ArtworkEvent {
  final int index;

  UpdateArtworkIndex(this.index);
}

class ToggleUndo extends ArtworkEvent {
  final bool canUndo;

  ToggleUndo(this.canUndo);
}
