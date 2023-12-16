import 'package:latlong2/latlong.dart';

abstract class LocationState {}

class LocationInitial extends LocationState {}

class LocationLoaded extends LocationState {
  final LatLng location;
  final double zoom;
  LocationLoaded(this.location, {this.zoom = 13.0});
}

class LocationError extends LocationState {
  final String message;
  LocationError(this.message);
}
