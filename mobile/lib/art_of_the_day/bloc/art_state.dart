import 'package:puam_app/art_of_the_day/index.dart';

abstract class ArtState {}

class ArtInitial extends ArtState {}

class ArtLoading extends ArtState {}

class ArtLoaded extends ArtState {
  final Artwork artwork;

  ArtLoaded(this.artwork);
}

class ArtError extends ArtState {
  final String message;

  ArtError(this.message);
}
