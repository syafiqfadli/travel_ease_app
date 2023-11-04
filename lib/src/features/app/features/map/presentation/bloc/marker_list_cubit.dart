import 'package:bloc/bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:travel_ease_app/src/features/app/core/domain/entities/place/place_entity.dart';
import 'package:travel_ease_app/src/features/app/core/domain/repositories/app_repo.dart';
import 'package:travel_ease_app/src/features/app/core/presentation/bloc/user_info_cubit.dart';
import 'package:travel_ease_app/src/features/app/features/map/presentation/bloc/select_place_cubit.dart';

class MarkerListCubit extends Cubit<List<Marker>> {
  final AppRepo appRepo;
  final UserInfoCubit userInfoCubit;
  final SelectPlaceCubit selectPlaceCubit;

  MarkerListCubit({
    required this.appRepo,
    required this.userInfoCubit,
    required this.selectPlaceCubit,
  }) : super([]);

  void getMarkerList() async {
    emit([]);

    final user = userInfoCubit.state as UserInfoLoaded;

    final placesEither = await appRepo.getPlacesCache(
      user.userEntity.email,
    );

    final places = placesEither.getOrElse(() => []);

    final filteredList = places.where((element) => element.hasMarker).toList();

    for (var place in filteredList) {
      Marker marker = Marker(
        markerId: MarkerId(place.placeId),
        position: LatLng(
          place.location.latitude,
          place.location.longitude,
        ),
        consumeTapEvents: true,
        onTap: () {
          _onMarkerTap(place);
        },
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
      consumeTapEvents: true,
      onTap: () {
        _onMarkerTap(place);
      },
    );

    final updatedList = [...state, marker];
    emit(updatedList);
  }

  void removeMarker(String placeId) {
    final itemIndex = state.indexWhere(
      (element) => placeId == element.markerId.value,
    );

    if (itemIndex == -1) {
      return;
    }

    state.removeAt(itemIndex);
    final updatedList = [...state];
    emit(updatedList);
  }

  void _onMarkerTap(PlaceEntity place) {
    selectPlaceCubit.placeSelected(place);
  }
}
