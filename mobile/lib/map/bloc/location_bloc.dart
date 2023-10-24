import 'dart:async';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:puam_app/map/index.dart';

class LocationBloc {
  final _locationController = StreamController<LocationState>();

  Stream<LocationState> get locationStream => _locationController.stream;

  void dispatch(LocationEvent event) {
    if (event is GetInitialLocation) {
      _getInitialLocation();
    } else if (event is RequestLocationPermission) {
      _requestLocationPermission();
    }
  }

  Future<void> _requestLocationPermission() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        await Geolocator.requestPermission();
      }
      dispatch(GetInitialLocation());
    } catch (e) {
      _locationController.sink.add(LocationError(e.toString()));
    }
  }

  Future<void> _getInitialLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition();
      _locationController.sink.add(LocationLoaded(
          LatLng(position.latitude, position.longitude),
          position)); // Update this
    } catch (e) {
      _locationController.sink.add(LocationError(e.toString()));
    }
  }

  void dispose() {
    _locationController.close();
  }
}
