abstract class FavEvent {}

class FetchFavoriteEvent extends FavEvent {
  final String artid;

  FetchFavoriteEvent({required this.artid});
}
