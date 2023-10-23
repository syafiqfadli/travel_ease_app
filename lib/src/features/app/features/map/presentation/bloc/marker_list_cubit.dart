import 'package:bloc/bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MarkerListCubit extends Cubit<List<Marker>> {
  MarkerListCubit() : super([]);

  void add(Marker marker) {
    final updatedList = [...state, marker];
    emit(updatedList);
  }

  void remove(String placeId) {
    final hasMarker = state.any((element) => element.markerId.value == placeId);

    if (!hasMarker) {
      return;
    }

    final itemIndex = state.indexWhere(
      (element) => placeId == element.markerId.value,
    );

    state.removeAt(itemIndex);
    final updatedList = [...state];
    emit(updatedList);
  }
}
