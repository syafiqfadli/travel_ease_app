import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:travel_ease_app/src/features/app/core/domain/entities/place/direction_entity.dart';
import 'package:travel_ease_app/src/features/app/core/domain/entities/place/location_entity.dart';
import 'package:travel_ease_app/src/features/app/core/domain/entities/place/place_entity.dart';
import 'package:travel_ease_app/src/features/app/core/domain/entities/place/price_entity.dart';
import 'package:travel_ease_app/src/features/app/core/domain/repositories/app_repo.dart';
import 'package:travel_ease_app/src/features/app/features/map/presentation/bloc/marker_list_cubit.dart';
import 'package:travel_ease_app/src/features/app/features/map/presentation/bloc/place_list_cubit.dart';
import 'package:travel_ease_app/src/features/app/features/map/presentation/bloc/polyline_list_cubit.dart';
import 'package:travel_ease_app/src/features/app/features/map/presentation/bloc/route_cubit.dart';
import 'package:travel_ease_app/src/features/app/features/map/presentation/bloc/select_place_cubit.dart';

part 'calculate_route_state.dart';

class CalculateRouteCubit extends Cubit<CalculateRouteState> {
  final AppRepo appRepo;
  final MarkerListCubit markerListCubit;
  final SelectPlaceCubit selectPlaceCubit;
  final PolylineListCubit polylineListCubit;
  final PlaceListCubit placeListCubit;
  final RouteCubit routeCubit;

  CalculateRouteCubit({
    required this.appRepo,
    required this.markerListCubit,
    required this.selectPlaceCubit,
    required this.polylineListCubit,
    required this.placeListCubit,
    required this.routeCubit,
  }) : super(CalculateRouteInitial());

  void calculateRoute() async {
    List<DirectionEntity> directionList = [];
    DirectionEntity directionEntity = DirectionEntity.empty;
    Map<String, double> cost = {};

    emit(const CalculateRouteLoading(status: 'Calculating route...'));

    final currentLocation = await Geolocator.getCurrentPosition();
    final apiPlacesEither = await appRepo.placeList();

    PlaceEntity currentPlace = PlaceEntity(
      placeId: 'your_location',
      placeName: 'Your Location',
      prices: const [],
      location: LocationEntity(
        longitude: currentLocation.longitude,
        latitude: currentLocation.latitude,
      ),
      isFavourite: false,
      businessHours: const [],
      rating: 0,
      address: 'NO_ADDRESS',
      phoneNo: 'NO_PHONE',
    );

    final placeList = [currentPlace, ...placeListCubit.state];
    final apiPlaces = apiPlacesEither.getOrElse(() => []);

    final newPlaces = _getPlacesWithPrice(placeList, apiPlaces);

    // Calculate cost
    for (var element in newPlaces) {
      _calculateCost(cost, element.prices);
      markerListCubit.addMarker(element);
    }

    // Calculate direction
    for (var i = 0; i < newPlaces.length; i++) {
      if (i == newPlaces.length - 1) {
        break;
      }

      final directionEither = await appRepo.getGoogleDirection(
        '${newPlaces[i].location.latitude},${newPlaces[i].location.longitude}',
        '${newPlaces[i + 1].location.latitude},${newPlaces[i + 1].location.longitude}',
      );

      final direction = directionEither.getOrElse(
        () => DirectionEntity.empty,
      );

      directionList.add(direction);
    }

    directionEntity = _calculateDirection(directionList);

    await _computePath(newPlaces);

    emit(CalculateRouteLoaded(
      direction: directionEntity,
      cost: cost,
      initPosition: currentPlace.location,
      places: newPlaces,
    ));
  }

  void _calculateCost(Map<String, double> cost, List<PriceEntity> prices) {
    for (var element in prices) {
      final category = element.category;
      final price = element.price;

      if (cost.containsKey(category)) {
        cost[category] = (cost[category] ?? 0) + price;
      } else {
        cost[category] = price;
      }
    }
  }

  DirectionEntity _calculateDirection(List<DirectionEntity> directionList) {
    int duration = 0;
    int distance = 0;

    for (var element in directionList) {
      duration += element.duration;
      distance += element.distance;
    }

    return DirectionEntity(distance: distance, duration: duration);
  }

  List<PlaceEntity> _getPlacesWithPrice(
    List<PlaceEntity> listA,
    List<PlaceEntity> listB,
  ) {
    List<PlaceEntity> commonElements = [];

    for (var itemA in listA) {
      for (var i = 0; i < listB.length; i++) {
        if (itemA.placeId == listB[i].placeId) {
          final tempPlace = PlaceEntity(
            placeId: itemA.placeId,
            placeName: itemA.placeName,
            prices: listB[i].prices,
            location: itemA.location,
            isFavourite: itemA.isFavourite,
            businessHours: itemA.businessHours,
            address: itemA.address,
            phoneNo: itemA.phoneNo,
            rating: itemA.rating,
          );

          commonElements.add(tempPlace);
          break;
        }

        if (itemA.placeId != listB[i].placeId && i == listB.length - 1) {
          commonElements.add(itemA);
        }
      }
    }

    return commonElements;
  }

  Future<void> _computePath(List<PlaceEntity> places) async {
    polylineListCubit.reset();
    routeCubit.reset();

    for (var index = 0; index < places.length; index++) {
      if (index == places.length - 1) {
        break;
      }

      LatLng start = LatLng(
        places[index].location.latitude,
        places[index].location.longitude,
      );

      LatLng end = LatLng(
        places[index + 1].location.latitude,
        places[index + 1].location.longitude,
      );

      await routeCubit.addRoute(start, end);
    }

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
    emit(CalculateRouteInitial());
  }
}
