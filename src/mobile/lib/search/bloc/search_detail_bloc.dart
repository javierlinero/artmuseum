import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:puam_app/search/index.dart';

class SearchDetailBloc extends Bloc<SearchDetailEvent, SearchDetailState> {
  final SearchDetailRepo _repository;

  SearchDetailBloc(this._repository) : super(SearchDetailInitial()) {
    on<FetchSearchDetailEvent>(_onFetchSearchDetailEvent);
  }

  Future<void> _onFetchSearchDetailEvent(
      FetchSearchDetailEvent event, Emitter<SearchDetailState> emit) async {
    emit(SearchDetailLoading());
    try {
      SearchDetails searchDetails = await _repository.getSearchDetail(event.artid);
      emit(SearchDetailLoaded(searchDetails));
    } catch (error) {
      emit(SearchDetailError(error.toString()));
    }
  }
}
