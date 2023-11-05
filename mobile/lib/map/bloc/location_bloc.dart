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
      final newZoomLevel = (currentState.zoom + 1)
          .clamp(15.0, 20.0); // Ensure the zoom level is within valid bounds
      mapController.move(currentState.location, newZoomLevel);
      emit(LocationLoaded(currentState.location, zoom: newZoomLevel));
    }
  }

  void _onZoomOut(ZoomOut event, Emitter<LocationState> emit) {
    if (state is LocationLoaded) {
      final currentState = state as LocationLoaded;
      final newZoomLevel = (currentState.zoom - 1)
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
      emit(LocationLoaded(LatLng(position.latitude, position.longitude)));
    } catch (e) {
      emit(LocationError("Failed to fetch location"));
    }
  }

  void _onZoomAndFollowCurrentLocation(
      ZoomAndFollowCurrentLocation event, Emitter<LocationState> emit) {
    _followCurrentLocationStreamController.add(18);
    add(FetchCurrentLocation());
  }

  @override
  Future<void> close() {
    _followCurrentLocationStreamController.close();
    return super.close();
  }
}
