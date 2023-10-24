import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

abstract class LocationState {}

class LocationInitial extends LocationState {}

class LocationPermissionRequired extends LocationState {}

class LocationLoaded extends LocationState {
  final LatLng position;

  final Position fullPosition;

  LocationLoaded(this.position, this.fullPosition);
}

class LocationError extends LocationState {
  final String message;

  LocationError(this.message);
}
