class Favorite {
  final String imageURL;
  final String artWorkID;

  Favorite({
    required this.imageURL,
    required this.artWorkID,
  });

  factory Favorite.fromJson(List<dynamic> json) {
    return Favorite(
      imageURL: json[1] as String,
      artWorkID: json[0].toString(),
    );
  }
}

List<Favorite> parseJson(List<dynamic> jsonList) {
  return jsonList.map((json) => Favorite.fromJson(json)).toList();
}
