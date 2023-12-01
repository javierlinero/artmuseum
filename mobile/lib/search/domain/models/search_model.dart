class SearchArtwork {
  final String artworkId;
  final String imageUrl;

  SearchArtwork({required this.artworkId, required this.imageUrl});

  factory SearchArtwork.fromList(List<dynamic> list) {
    return SearchArtwork(
      artworkId: list[0].toString(),
      imageUrl: list[1].toString(),
    );
  }
}
