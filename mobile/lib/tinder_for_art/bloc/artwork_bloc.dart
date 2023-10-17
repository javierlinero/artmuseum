import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:puam_app/tinder_for_art/index.dart';

class ArtworkBloc extends Bloc<ArtworkEvent, ArtworkState> {
  ArtworkBloc() : super(ArtworkState(0)) {
    on<UpdateArtworkIndex>((event, emit) {
      emit(ArtworkState(event.index));
    });
  }
}
