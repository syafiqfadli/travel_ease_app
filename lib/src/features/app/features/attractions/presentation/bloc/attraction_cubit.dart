import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:travel_ease_app/src/core/utils/constants.dart';
import 'package:travel_ease_app/src/features/app/core/domain/entities/place/location_entity.dart';
import 'package:travel_ease_app/src/features/app/core/domain/entities/place/place_entity.dart';
import 'package:travel_ease_app/src/features/app/core/domain/repositories/app_repo.dart';

part 'attraction_state.dart';

class AttractionCubit extends Cubit<AttractionState> {
  final AppRepo appRepo;

  AttractionCubit({required this.appRepo}) : super(AttractionInitial());

  void getPlaces(
    String placeName,
    LocationEntity locationEntity,
  ) async {
    emit(AttractionLoading(message: 'Finding places in $placeName...'));

    final placesEither = await appRepo.getNearbyCache(
      key: LocalKey.attractionKey,
      placeName: placeName,
      location: locationEntity,
    );

    final places = placesEither.getOrElse(() => []);

    if (places.isNotEmpty) {
      emit(AttractionLoaded(places: places));
      return;
    }

    emit(const AttractionLoading(message: 'Finding nearby museum...'));

    final museumEither = await appRepo.searchGoogleNearby(
      placeName: placeName,
      type: 'museum',
      locationEntity: locationEntity,
      isAttraction: true,
    );

    emit(const AttractionLoading(message: 'Finding nearby aquarium...'));

    final aquariumEither = await appRepo.searchGoogleNearby(
      placeName: placeName,
      type: 'aquarium',
      locationEntity: locationEntity,
      isAttraction: true,
    );

    emit(const AttractionLoading(message: 'Finding nearby attractions...'));

    final touristEither = await appRepo.searchGoogleNearby(
      placeName: placeName,
      type: 'tourist_attraction',
      locationEntity: locationEntity,
      isAttraction: true,
    );

    final museum = museumEither.getOrElse(() => []);
    final aquarium = aquariumEither.getOrElse(() => []);
    final tourist = touristEither.getOrElse(() => []);

    final placeList = [...museum, ...aquarium, ...tourist];

    emit(AttractionLoaded(places: placeList));
  }
}
