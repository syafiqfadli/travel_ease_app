import 'package:bloc/bloc.dart';
import 'package:travel_ease_app/src/features/app/core/domain/entities/place/place_entity.dart';
import 'package:travel_ease_app/src/features/app/core/domain/repositories/app_repo.dart';
import 'package:travel_ease_app/src/features/app/core/presentation/bloc/user_info_cubit.dart';

class SelectPlaceCubit extends Cubit<PlaceEntity?> {
  final AppRepo appRepo;
  final UserInfoCubit userInfoCubit;
  SelectPlaceCubit({
    required this.appRepo,
    required this.userInfoCubit,
  }) : super(null);

  void placeSelected(PlaceEntity place) async {
    final user = userInfoCubit.state as UserInfoLoaded;

    final placesEither = await appRepo.getPlacesCache(
      user.userEntity.email,
    );

    final places = placesEither.getOrElse(() => []);

    for (var data in places) {
      if (data.placeId == place.placeId) {
        emit(data);
        return;
      }
    }

    emit(place);
  }

  void setFavouritePlace(PlaceEntity place) async {
    final user = userInfoCubit.state as UserInfoLoaded;

    final tempPlace = PlaceEntity(
      placeId: place.placeId,
      placeName: place.placeName,
      prices: place.prices,
      location: place.location,
      isFavourite: !place.isFavourite,
      hasMarker: place.hasMarker,
      businessHours: place.businessHours,
      address: place.address,
      phoneNo: place.phoneNo,
    );

    await appRepo.setPlacesCache(
      user.userEntity.email,
      tempPlace,
    );

    emit(tempPlace);
  }

  void setMarker(PlaceEntity place) async {
    final user = userInfoCubit.state as UserInfoLoaded;

    final tempPlace = PlaceEntity(
      placeId: place.placeId,
      placeName: place.placeName,
      prices: place.prices,
      location: place.location,
      isFavourite: place.isFavourite,
      hasMarker: !place.hasMarker,
      businessHours: place.businessHours,
      address: place.address,
      phoneNo: place.phoneNo,
    );

    await appRepo.setPlacesCache(
      user.userEntity.email,
      tempPlace,
    );

    emit(tempPlace);
  }

  void removePlace() {
    emit(null);
  }
}
