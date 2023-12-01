import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:puam_app/search/index.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final SearchRepo searchRepo;

  SearchBloc({required this.searchRepo}) : super(SearchInitial()) {
    on<SearchArtworksEvent>(_onSearchArtworks);
  }

  Future<void> _onSearchArtworks(
      SearchArtworksEvent event, Emitter<SearchState> emit) async {
    emit(SearchLoading());
    try {
      final artworks = await searchRepo.searchArtworks(event.query,
          limit: event.limit, offset: event.offset);
      emit(SearchLoaded(artworks: artworks));
    } catch (e) {
      emit(SearchError(message: e.toString()));
    }
  }
}
