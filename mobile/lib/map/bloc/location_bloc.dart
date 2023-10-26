import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:puam_app/map/bloc/index.dart';

class LocationBloc extends Bloc<LocationEvent, LocationState> {
  LocationBloc() : super(LocationInitial()) {
    on<FetchCurrentLocation>(_onFetchCurrentLocation);
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
}
