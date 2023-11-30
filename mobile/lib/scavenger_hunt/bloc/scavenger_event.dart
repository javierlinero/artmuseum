import 'package:geolocator/geolocator.dart';

abstract class ScavengerHuntEvent {}

class StartScavengerHunt extends ScavengerHuntEvent {
  final int artworkCount;

  StartScavengerHunt(this.artworkCount);
}

class UpdateUserLocation extends ScavengerHuntEvent {
  final Position userLocation;

  UpdateUserLocation(this.userLocation);
}

class ArtworkFound extends ScavengerHuntEvent {}

class EndScavengerHunt extends ScavengerHuntEvent {}
