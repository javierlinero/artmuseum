import 'package:puam_app/user_profile/index.dart';

abstract class FavState {}

class FavInitial extends FavState {}

class FavLoading extends FavState {}

class FavLoaded extends FavState {
  final FavoritesDetails favoritesDetails;

  FavLoaded(this.favoritesDetails);
}

class FavError extends FavState {
  final String message;

  FavError(this.message);
}
