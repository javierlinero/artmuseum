
import 'package:puam_app/search/index.dart';

abstract class SearchDetailState {}

class SearchDetailInitial extends SearchDetailState {}

class SearchDetailLoading extends SearchDetailState {}

class SearchDetailLoaded extends SearchDetailState {
  final SearchDetails searchDetails;

  SearchDetailLoaded(this.searchDetails);
}

class SearchDetailError extends SearchDetailState {
  final String message;

  SearchDetailError(this.message);
}
