import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:travel_ease_app/src/features/app/core/domain/entities/place/place_entity.dart';
import 'package:travel_ease_app/src/features/app/core/domain/repositories/app_repo.dart';
import 'package:travel_ease_app/src/features/app/core/presentation/bloc/user_info_cubit.dart';
import 'package:travel_ease_app/src/features/app/features/map/presentation/bloc/marker_list_cubit.dart';
import 'package:travel_ease_app/src/features/app/features/map/presentation/bloc/polyline_list_cubit.dart';
import 'package:travel_ease_app/src/features/app/features/map/presentation/bloc/route_cubit.dart';

class ShowRouteCubit extends Cubit<List<PlaceEntity>> {
  final AppRepo appRepo;
  final UserInfoCubit userInfoCubit;
  final PolylineListCubit polylineListCubit;
  final MarkerListCubit markerListCubit;
  final RouteCubit routeCubit;

  ShowRouteCubit({
    required this.routeCubit,
    required this.polylineListCubit,
    required this.markerListCubit,
    required this.appRepo,
    required this.userInfoCubit,
  }) : super([]);

  void getRouteList() async {
    final user = userInfoCubit.state as UserInfoLoaded;

    final apiPlacesEither = await appRepo.placeList();
    final placesEither = await appRepo.getPlacesCache(
      user.userEntity.email,
    );

    final apiPlaces = apiPlacesEither.getOrElse(() => []);
    final places = placesEither.getOrElse(() => []);

    final filteredList = places.where((element) => element.hasMarker).toList();

    final newPlaces = _getPlacesWithPrice(filteredList, apiPlaces);

    emit(newPlaces);
  }

  void removeRoute(PlaceEntity place) async {
    final user = userInfoCubit.state as UserInfoLoaded;

    final tempPlace = PlaceEntity(
      placeId: place.placeId,
      placeName: place.placeName,
      prices: place.prices,
      location: place.location,
      isFavourite: place.isFavourite,
      hasMarker: false,
      businessHours: place.businessHours,
      address: place.address,
      phoneNo: place.phoneNo,
      rating: place.rating,
      tags: place.tags,
    );

    await appRepo.setPlacesCache(
      user.userEntity.email,
      tempPlace,
    );

    markerListCubit.removeMarker(place.placeId);
    routeCubit.reset();
    polylineListCubit.reset();

    getRouteList();
  }

  void computePath(int index) async {
    routeCubit.reset();
    polylineListCubit.reset();

    if (index == state.length - 1) {
      return;
    }

    LatLng start = LatLng(
      state[index].location.latitude,
      state[index].location.longitude,
    );
    LatLng end = LatLng(
      state[index + 1].location.latitude,
      state[index + 1].location.longitude,
    );

    await routeCubit.addRoute(start, end);

    final polyline = Polyline(
      polylineId: const PolylineId('iter'),
      visible: true,
      points: routeCubit.state,
      width: 4,
      color: Colors.blue,
      startCap: Cap.roundCap,
      endCap: Cap.buttCap,
    );

    polylineListCubit.addPolyline(polyline);
  }

  void reset() {
    emit([]);
    polylineListCubit.reset();
    routeCubit.reset();
  }

  List<PlaceEntity> _getPlacesWithPrice(
    List<PlaceEntity> listA,
    List<PlaceEntity> listB,
  ) {
    List<PlaceEntity> commonElements = [];

    for (var itemA in listA) {
      for (var itemB in listB) {
        if (itemA.placeId == itemB.placeId) {
          final tempPlace = PlaceEntity(
            placeId: itemA.placeId,
            placeName: itemA.placeName,
            prices: itemB.prices,
            location: itemA.location,
            isFavourite: itemA.isFavourite,
            hasMarker: itemA.hasMarker,
            businessHours: itemA.businessHours,
            address: itemA.address,
            phoneNo: itemA.phoneNo,
            rating: itemA.rating,
            tags: itemA.tags,
          );

          commonElements.add(tempPlace);
          break;
        }
      }
    }

    return commonElements;
  }
}
