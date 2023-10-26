import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:puam_app/map/bloc/index.dart';

class LocationBloc extends Bloc<LocationEvent, LocationState> {
  final _followCurrentLocationStreamController = StreamController<double?>();

  Stream<double?> get followCurrentLocationStream =>
      _followCurrentLocationStreamController.stream;

  LocationBloc() : super(LocationInitial()) {
    on<FetchCurrentLocation>(_onFetchCurrentLocation);
    on<ZoomAndFollowCurrentLocation>(_onZoomAndFollowCurrentLocation);
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
