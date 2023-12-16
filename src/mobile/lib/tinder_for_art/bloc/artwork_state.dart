import 'package:equatable/equatable.dart';
import 'package:puam_app/tinder_for_art/index.dart';

class ArtworkState extends Equatable {
  final int currentIndex;
  final bool canUndo;
  final List<TinderArt> recommendations;
  final bool isLoading;
  final String? error;

  ArtworkState({
    required this.currentIndex,
    this.canUndo = false,
    this.recommendations = const [],
    this.isLoading = false,
    this.error,
  });

  ArtworkState copyWith({
    int? currentIndex,
    bool? canUndo,
    List<TinderArt>? recommendations,
    bool? isLoading,
    String? error,
  }) {
    return ArtworkState(
      currentIndex: currentIndex ?? this.currentIndex,
      canUndo: canUndo ?? this.canUndo,
      recommendations: recommendations ?? this.recommendations,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props =>
      [currentIndex, canUndo, recommendations, isLoading, error];
}
