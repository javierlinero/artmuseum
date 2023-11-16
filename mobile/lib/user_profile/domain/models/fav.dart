class Favorite {
  final String imageURL;
  final String artWorkID;

  Favorite({
    required this.imageURL,
    required this.artWorkID,
  });

  factory Favorite.fromJson(Map<String, dynamic> json) {
    return Favorite(imageURL: json['imageUrl'], artWorkID: json['artworkId']);
  }
}
