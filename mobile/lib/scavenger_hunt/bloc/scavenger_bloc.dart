import 'dart:async';
import 'dart:math';

import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:puam_app/map/index.dart';
import 'package:puam_app/scavenger_hunt/index.dart';

class ArtworkScavengerHuntBloc
    extends Bloc<ScavengerHuntEvent, ScavengerHuntState> {
  final List<CampusArtwork> artworks;
  final Random _random = Random();
  List<CampusArtwork> _remainingArtworks;
  CampusArtwork? currentTarget;
  StreamSubscription<Position>? _positionStreamSubscription;

  ArtworkScavengerHuntBloc({required this.artworks})
      : _remainingArtworks = List.from(artworks),
        super(ScavengerHuntInitial()) {
    on<StartScavengerHunt>(_onStartScavengerHunt);
    on<UpdateUserLocation>(_onUpdateUserLocation);
    on<ArtworkFound>(_onArtworkFound);
    on<EndScavengerHunt>((event, emit) => emit(ScavengerHuntInitial()));
    _startListeningToLocation();
  }

  void _startListeningToLocation() {
    const locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 5,
    );

    _positionStreamSubscription =
        Geolocator.getPositionStream(locationSettings: locationSettings).listen(
      (Position position) {
        add(UpdateUserLocation(position));
      },
    );
  }

  void getLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);
    add(UpdateUserLocation(position));
  }

  @override
  Future<void> close() {
    _positionStreamSubscription?.cancel();
    return super.close();
  }

  void _onStartScavengerHunt(
      StartScavengerHunt event, Emitter<ScavengerHuntState> emit) {
    // Reset the list of remaining artworks
    _remainingArtworks = List.from(artworks);

    // Randomly shuffle the list and pick the first N artworks based on the event.artworkCount
    _remainingArtworks.shuffle();
    _remainingArtworks = _remainingArtworks.take(event.artworkCount).toList();

    _selectNextTarget();
    if (currentTarget != null) {
      debugPrint(currentTarget!.name);
      emit(ScavengerHuntInProgress(currentTarget!, 'Starting'));
      getLocation();
    } else {
      emit(ScavengerHuntError('No artworks available for the scavenger hunt'));
    }
  }

  void _onUpdateUserLocation(
      UpdateUserLocation event, Emitter<ScavengerHuntState> emit) {
    if (currentTarget == null) {
      emit(ScavengerHuntError('No current target set.'));
      return;
    }

    final double distance = Geolocator.distanceBetween(
      event.userLocation.latitude,
      event.userLocation.longitude,
      currentTarget!.lat,
      currentTarget!.long,
    );

    // Convert distance to a human-readable format and determine proximity
    String proximityHint = _getProximityHint(distance);

    emit(ScavengerHuntInProgress(currentTarget!, proximityHint));
  }

  String _getProximityHint(double distance) {
    String roundedDistance = distance.toStringAsFixed(0);
    // Define distance thresholds for different hints
    const double hotThreshold = 20;
    const double warmThreshold = 100;
    const double coldThreshold = 250;
    const double farAwayThreshold = 500;

    if (distance <= hotThreshold) {
      return 'Hot: $roundedDistance meters away.';
    } else if (distance <= warmThreshold) {
      return 'Warm: $roundedDistance meters away.';
    } else if (distance <= coldThreshold) {
      return 'Cold: $roundedDistance meters away.';
    } else if (distance <= farAwayThreshold) {
      return 'Colder: $roundedDistance meters away.';
    } else {
      return 'Far Away: $roundedDistance meters away.';
    }
  }

  void _onArtworkFound(ArtworkFound event, Emitter<ScavengerHuntState> emit) {
    _selectNextTarget();
    if (currentTarget != null) {
      debugPrint('Next: ${currentTarget!.name}');
      emit(ScavengerHuntInProgress(
          currentTarget!, 'Artwork Found! Searching next...'));
      getLocation();
    } else {
      emit(ScavengerHuntCompleted());
    }
  }

  void _selectNextTarget() {
    if (_remainingArtworks.isNotEmpty) {
      int nextIndex = _random.nextInt(_remainingArtworks.length);
      currentTarget = _remainingArtworks[nextIndex];
      _remainingArtworks.removeAt(nextIndex);
    } else {
      currentTarget = null;
    }
  }
}
