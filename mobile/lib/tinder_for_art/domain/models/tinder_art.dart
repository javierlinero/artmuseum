class TinderArt {
  final int artworkId;
  final String imageUrl;

  TinderArt({
    required this.artworkId,
    required this.imageUrl,
  });

  // Convert a TinderArt instance into a map.
  Map<String, dynamic> toJson() {
    return {
      'artworkId': artworkId,
      'imageUrl': imageUrl,
    };
  }

  // Extract a TinderArt object from a map.
  static TinderArt fromJson(Map<String, dynamic> json) {
    return TinderArt(
      artworkId: json['artworkId'],
      imageUrl: json['imageUrl'],
    );
  }
}
