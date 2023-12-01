abstract class SearchEvent {}

class SearchArtworksEvent extends SearchEvent {
  final String query;
  final int? limit;
  int? offset;

  SearchArtworksEvent({required this.query, this.limit, this.offset});
}
