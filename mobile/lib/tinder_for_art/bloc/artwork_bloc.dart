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

    on<SaveArtworks>((event, emit) async {
      int startIndex = state.currentIndex;
      List<TinderArt> artworksToSave = event.artworks.sublist(startIndex);
      await LocalStorageHelper.saveArtworks(artworksToSave);
      emit(state.copyWith(isLoading: false));
    });

    on<ToggleUndo>((event, emit) {
      emit(state.copyWith(canUndo: event.canUndo));
    });

    on<LoadSavedArtworks>(_onLoadSavedArtworks);
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

  Future<void> _onLoadSavedArtworks(
      LoadSavedArtworks event, Emitter<ArtworkState> emit) async {
    emit(state.copyWith(isLoading: true));
    try {
      List<TinderArt>? savedArtworks = await LocalStorageHelper.loadArtworks();
      if (savedArtworks != null && savedArtworks.isNotEmpty) {
        emit(state.copyWith(
            recommendations: savedArtworks, currentIndex: 0, isLoading: false));
      } else {
        // Handle the case where no saved artworks are available
        emit(state.copyWith(isLoading: false));
      }
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }
}
