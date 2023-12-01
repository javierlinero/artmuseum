class SearchArtwork {
  final String artworkId;
  final String imageUrl;

  SearchArtwork({required this.artworkId, required this.imageUrl});

  factory SearchArtwork.fromJson(Map<String, dynamic> json) {
    return SearchArtwork(
      artworkId: json['artworkId'],
      imageUrl: json['imageUrl'],
    );
  }
}
