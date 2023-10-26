import 'package:latlong2/latlong.dart';

abstract class LocationState {}

class LocationInitial extends LocationState {}

class LocationLoaded extends LocationState {
  final LatLng location;

  LocationLoaded(this.location);
}

class LocationError extends LocationState {
  final String message;

  LocationError(this.message);
}
