abstract class ArtEvent {}

class FetchArtOfTheDayEvent extends ArtEvent {
  String? token;
  FetchArtOfTheDayEvent({this.token});
}
