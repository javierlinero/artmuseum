import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:puam_app/user_profile/index.dart';

class FavBloc extends Bloc<FavEvent, FavState> {
  final FavoriteRepo _repository;

  FavBloc(this._repository) : super(FavInitial()) {
    on<FetchFavoriteEvent>(_onFetchFavoriteEvent);
  }

  Future<void> _onFetchFavoriteEvent(
      FetchFavoriteEvent event, Emitter<FavState> emit) async {
    emit(FavLoading());
    try {
      FavoritesDetails favoritesDetails = await _repository.getFavorite(event.artid);
      emit(FavLoaded(favoritesDetails));
    } catch (error) {
      emit(FavError(error.toString()));
    }
  }
}
