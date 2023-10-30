import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:puam_app/art_of_the_day/index.dart';

class ArtBloc extends Bloc<ArtEvent, ArtState> {
  final ArtworkRepository _repository;

  ArtBloc(this._repository) : super(ArtInitial());

  Stream<ArtState> mapEventToState(ArtEvent event) async* {
    if (event is FetchArtOfTheDayEvent) {
      yield ArtLoading();
      try {
        Artwork artwork = await _repository.getArtOfTheDay();
        yield ArtLoaded(artwork);
      } catch (error) {
        yield ArtError(error.toString());
      }
    }
  }
}
