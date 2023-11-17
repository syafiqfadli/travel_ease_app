import 'package:bloc/bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:travel_ease_app/src/features/app/core/domain/entities/place/place_entity.dart';
import 'package:travel_ease_app/src/features/app/core/domain/repositories/app_repo.dart';
import 'package:travel_ease_app/src/features/app/features/map/presentation/bloc/place_list_cubit.dart';

class MarkerListCubit extends Cubit<List<Marker>> {
  final AppRepo appRepo;
  final PlaceListCubit placeListCubit;

  MarkerListCubit({
    required this.appRepo,
    required this.placeListCubit,
  }) : super([]);

  void getMarkerList() async {
    emit([]);

    final places = placeListCubit.state;

    for (var place in places) {
      Marker marker = Marker(
        markerId: MarkerId(place.placeId),
        position: LatLng(
          place.location.latitude,
          place.location.longitude,
        ),
      );

      state.add(marker);
    }

    emit(state);
  }

  void addMarker(PlaceEntity place) {
    Marker marker = Marker(
      markerId: MarkerId(place.placeId),
      position: LatLng(
        place.location.latitude,
        place.location.longitude,
      ),
    );

    final updatedList = [...state, marker];
    emit(updatedList);
  }
}
