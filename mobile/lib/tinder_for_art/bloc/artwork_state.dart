import 'package:equatable/equatable.dart';

class ArtworkState extends Equatable {
  final int currentIndex;

  ArtworkState(this.currentIndex);

  @override
  List<Object?> get props => [currentIndex];
}
