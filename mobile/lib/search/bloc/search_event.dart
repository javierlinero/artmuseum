abstract class SearchEvent {}

class SearchArtworksEvent extends SearchEvent {
  final String query;
  final int? limit;

  SearchArtworksEvent({required this.query, this.limit});
}
