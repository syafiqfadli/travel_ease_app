import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:travel_ease_app/src/features/app/core/domain/entities/place/place_entity.dart';
import 'package:travel_ease_app/src/features/app/core/domain/repositories/app_repo.dart';
import 'package:travel_ease_app/src/features/app/core/presentation/bloc/user_info_cubit.dart';

part 'favourite_list_state.dart';

class FavouriteListCubit extends Cubit<FavouriteListState> {
  final AppRepo appRepo;
  final UserInfoCubit userInfoCubit;

  FavouriteListCubit({
    required this.appRepo,
    required this.userInfoCubit,
  }) : super(FavouriteInitial());

  void getFavouritePlaces() async {
    final user = userInfoCubit.state as UserInfoLoaded;

    final placesEither = await appRepo.getPlacesCache(
      user.userEntity.email,
    );

    final places = placesEither.getOrElse(() => []);

    final filteredPlaces =
        places.where((element) => element.isFavourite).toList();

    emit(FavouriteLoaded(places: filteredPlaces));
  }

  void removeFavourite(PlaceEntity place) async {
    final user = userInfoCubit.state as UserInfoLoaded;

    final tempPlace = PlaceEntity(
      placeId: place.placeId,
      placeName: place.placeName,
      prices: place.prices,
      location: place.location,
      isFavourite: false,
      hasMarker: place.hasMarker,
      businessHours: place.businessHours,
      address: place.address,
      phoneNo: place.phoneNo,
    );

    await appRepo.setPlacesCache(
      user.userEntity.email,
      tempPlace,
    );

    getFavouritePlaces();
  }
}
