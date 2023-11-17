import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:puam_app/tinder_for_art/index.dart';

class TinderArtBloc extends Bloc<ArtworkEvent, ArtworkState> {
  final TinderForArtRepository repository;
  TinderArtBloc({required this.repository})
      : super(ArtworkState(currentIndex: 0)) {
    on<FetchArtworkRecommendations>(_onFetchArtworkRecommendations);
    on<UpdateArtworkIndex>((event, emit) {
      emit(state.copyWith(
        currentIndex: event.index,
        canUndo: true,
      ));
    });

    on<ToggleUndo>((event, emit) {
      emit(state.copyWith(canUndo: event.canUndo));
    });
  }
  Future<void> _onFetchArtworkRecommendations(
      FetchArtworkRecommendations event, Emitter<ArtworkState> emit) async {
    emit(state.copyWith(isLoading: true));
    try {
      final recommendations =
          await repository.getArtSuggestions(event.numSuggestions, event.token);
      emit(state.copyWith(isLoading: false, recommendations: recommendations));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }
}
