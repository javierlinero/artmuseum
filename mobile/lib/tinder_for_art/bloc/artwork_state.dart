import 'package:equatable/equatable.dart';

class ArtworkState extends Equatable {
  final int currentIndex;
  final bool canUndo;

  ArtworkState({required this.currentIndex, this.canUndo = false});

  ArtworkState copyWith({int? currentIndex, bool? canUndo}) {
    return ArtworkState(
      currentIndex: currentIndex ?? this.currentIndex,
      canUndo: canUndo ?? this.canUndo,
    );
  }

  @override
  List<Object?> get props => [currentIndex, canUndo];
}
