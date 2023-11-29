import 'package:puam_app/map/index.dart';

abstract class ScavengerHuntState {}

class ScavengerHuntInitial extends ScavengerHuntState {}

class ScavengerHuntInProgress extends ScavengerHuntState {
  final CampusArtwork currentTarget;
  final String proximityHint;

  ScavengerHuntInProgress(this.currentTarget, this.proximityHint);
}

class ScavengerHuntCompleted extends ScavengerHuntState {}

class ScavengerHuntError extends ScavengerHuntState {
  final String message;

  ScavengerHuntError(this.message);
}
