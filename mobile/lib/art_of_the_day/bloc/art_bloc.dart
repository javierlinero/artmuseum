import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:puam_app/art_of_the_day/index.dart';

class ArtBloc extends Bloc<ArtEvent, ArtState> {
  final ArtworkRepository _repository;

  ArtBloc(this._repository) : super(ArtInitial()) {
    on<FetchArtOfTheDayEvent>(_onFetchArtOfTheDayEvent);
  }

  Future<void> _onFetchArtOfTheDayEvent(
      FetchArtOfTheDayEvent event, Emitter<ArtState> emit) async {
    emit(ArtLoading());
    try {
      Artwork artwork = await _repository.getArtOfTheDay(event.token);
      emit(ArtLoaded(artwork));
    } catch (error) {
      emit(ArtError(error.toString()));
    }
  }
}
