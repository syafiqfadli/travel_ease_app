import 'package:bloc/bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PolylineListCubit extends Cubit<List<Polyline>> {
  PolylineListCubit() : super([]);

  void addPolyline(Polyline polyline) {
    final updatedList = [...state, polyline];
    emit(updatedList);
  }

  void reset() {
    emit([]);
  }
}
