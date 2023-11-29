import 'package:puam_app/map/index.dart';

abstract class ScavengerHuntState {}

class ScavengerHuntInitial extends ScavengerHuntState {}

class ScavengerHuntInProgress extends ScavengerHuntState {
  final CampusArtwork currentTarget;
  final String proximityHint;
  final double distance;

  ScavengerHuntInProgress(
      this.currentTarget, this.proximityHint, this.distance);
}

class ScavengerHuntCompleted extends ScavengerHuntState {}

class ScavengerHuntError extends ScavengerHuntState {
  final String message;

  ScavengerHuntError(this.message);
}
