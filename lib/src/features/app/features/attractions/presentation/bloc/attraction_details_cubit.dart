import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:travel_ease_app/src/features/app/core/domain/entities/place/place_entity.dart';
import 'package:travel_ease_app/src/features/app/core/domain/repositories/app_repo.dart';

part 'attraction_details_state.dart';

class AttractionDetailsCubit extends Cubit<AttractionDetailsState> {
  final AppRepo appRepo;

  AttractionDetailsCubit({required this.appRepo})
      : super(AttractionDetailsInitial());

  void getPlaceDetails(String placeId) async {
    emit(AttractionDetailsLoading());

    final placeEither = await appRepo.getGooglePlaceDetails(placeId);
    final apiPlacesEither = await appRepo.placeList();

    final place = placeEither.getOrElse(() => PlaceEntity.empty);
    final places = apiPlacesEither.getOrElse(() => []);

    final newPlace = _placeWithPrice(places, place);

    emit(AttractionDetailsLoaded(place: newPlace));
  }

  PlaceEntity _placeWithPrice(
    List<PlaceEntity> places,
    PlaceEntity place,
  ) {
    PlaceEntity tempPlace = PlaceEntity.empty;

    for (var newPlace in places) {
      if (newPlace.placeId == place.placeId) {
        tempPlace = PlaceEntity(
          placeId: place.placeId,
          placeName: place.placeName,
          prices: newPlace.prices,
          location: place.location,
          isFavourite: place.isFavourite,
          businessHours: place.businessHours,
          address: place.address,
          phoneNo: place.phoneNo,
          rating: place.rating,
        );

        break;
      }

      tempPlace = place;
    }

    return tempPlace;
  }
}
