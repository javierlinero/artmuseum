abstract class ArtworkEvent {}

class UpdateArtworkIndex extends ArtworkEvent {
  final int index;

  UpdateArtworkIndex(this.index);
}
