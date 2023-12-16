abstract class SearchDetailEvent {}

class FetchSearchDetailEvent extends SearchDetailEvent {
  final String artid;

  FetchSearchDetailEvent({required this.artid});
}
