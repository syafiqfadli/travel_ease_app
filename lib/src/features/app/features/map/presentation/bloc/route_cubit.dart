import 'package:bloc/bloc.dart';
import 'package:google_map_polyline_new/google_map_polyline_new.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class RouteCubit extends Cubit<List<LatLng>> {
  final GoogleMapPolyline googleMapPolyline;

  RouteCubit({required this.googleMapPolyline}) : super([]);

  Future<void> addRoute(LatLng start, LatLng end) async {
    final routeList = await googleMapPolyline.getCoordinatesWithLocation(
      origin: start,
      destination: end,
      mode: RouteMode.driving,
    );

    state.addAll(routeList!);

    emit(state);
  }

  void reset() {
    emit([]);
  }
}
