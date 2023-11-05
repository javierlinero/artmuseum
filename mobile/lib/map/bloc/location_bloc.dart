import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:puam_app/map/bloc/index.dart';

class LocationBloc extends Bloc<LocationEvent, LocationState> {
  final _followCurrentLocationStreamController = StreamController<double?>();
  final MapController mapController;

  Stream<double?> get followCurrentLocationStream =>
      _followCurrentLocationStreamController.stream;

  LocationBloc(this.mapController) : super(LocationInitial()) {
    on<FetchCurrentLocation>(_onFetchCurrentLocation);
    on<ZoomAndFollowCurrentLocation>(_onZoomAndFollowCurrentLocation);
    on<ZoomIn>(_onZoomIn);
    on<ZoomOut>(_onZoomOut);
  }

  void _onZoomIn(ZoomIn event, Emitter<LocationState> emit) {
    if (state is LocationLoaded) {
      final currentState = state as LocationLoaded;
      final newZoomLevel = (currentState.zoom + 0.5)
          .clamp(15.0, 20.0); // Ensure the zoom level is within valid bounds
      mapController.move(currentState.location, newZoomLevel);
      emit(LocationLoaded(currentState.location, zoom: newZoomLevel));
    }
  }

  void _onZoomOut(ZoomOut event, Emitter<LocationState> emit) {
    if (state is LocationLoaded) {
      final currentState = state as LocationLoaded;
      final newZoomLevel = (currentState.zoom - 0.5)
          .clamp(15.0, 20.0); // Ensure the zoom level is within valid bounds
      mapController.move(currentState.location, newZoomLevel);
      emit(LocationLoaded(currentState.location, zoom: newZoomLevel));
    }
  }

  void _onFetchCurrentLocation(
      FetchCurrentLocation event, Emitter<LocationState> emit) async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      // Get the current zoom level or default to a specific value if not available
      final currentZoom =
          state is LocationLoaded ? (state as LocationLoaded).zoom : 18.0;
      emit(LocationLoaded(LatLng(position.latitude, position.longitude),
          zoom: currentZoom));
    } catch (e) {
      emit(LocationError("Failed to fetch location"));
    }
  }

  void _onZoomAndFollowCurrentLocation(
      ZoomAndFollowCurrentLocation event, Emitter<LocationState> emit) {
    // Set a desired zoom level when following the current location
    const desiredZoomLevel = 18.0;

    // Add the desired zoom level to the stream controller for other widgets
    // that might be listening to changes in the current location's zoom level.
    _followCurrentLocationStreamController.add(desiredZoomLevel);

    // Check if the current state already has a location loaded
    if (state is LocationLoaded) {
      final currentState = state as LocationLoaded;
      // Move the map to the current location with the desired zoom level
      mapController.move(currentState.location, desiredZoomLevel);
      // Emit the new state with the current location and updated zoom level
      emit(LocationLoaded(currentState.location, zoom: desiredZoomLevel));
    } else {
      // If the location is not already loaded, fetch it.
      add(FetchCurrentLocation());
    }
  }

  @override
  Future<void> close() {
    _followCurrentLocationStreamController.close();
    return super.close();
  }
}
