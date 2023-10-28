import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';
import 'package:travel_ease_app/src/features/app/core/domain/entities/place/location_entity.dart';
import 'package:travel_ease_app/src/features/app/core/domain/entities/place/place_entity.dart';
import 'package:travel_ease_app/src/features/app/core/domain/repositories/app_repo.dart';

part 'nearby_places_state.dart';

class NearbyPlacesCubit extends Cubit<NearbyPlacesState> {
  final AppRepo appRepo;

  NearbyPlacesCubit({required this.appRepo}) : super(NearbyPlacesInitial());

  void searchPlaces() async {
    emit(const NearbyPlacesLoading(status: "Getting your current location..."));

    final location = await Geolocator.getCurrentPosition();

    emit(const NearbyPlacesLoading(status: "Finding nearby attractions..."));

    final locationEntity = LocationEntity(
      longitude: location.longitude,
      latitude: location.latitude,
    );

    final placesEither = await appRepo.searchGoogleNearby(
      type: 'tourist_attraction',
      isAttraction: false,
      locationEntity: locationEntity,
    );

    placesEither.fold(
      (failure) => emit(NearbyPlacesError(message: failure.message)),
      (places) {
        emit(NearbyPlacesLoaded(places: places));
      },
    );
  }

  void clearSearch() {
    emit(NearbyPlacesInitial());
  }
}
