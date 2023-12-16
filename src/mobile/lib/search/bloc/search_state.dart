import 'package:puam_app/search/index.dart';

abstract class SearchState {}

class SearchInitial extends SearchState {}

class SearchLoading extends SearchState {}

class SearchLoaded extends SearchState {
  final List<SearchArtwork> artworks;

  SearchLoaded({required this.artworks});
}

class SearchError extends SearchState {
  final String message;

  SearchError({required this.message});
}
