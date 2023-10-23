import 'package:bloc/bloc.dart';
import 'package:travel_ease_app/src/features/app/core/domain/entities/place/place_entity.dart';
import 'package:travel_ease_app/src/features/app/core/domain/repositories/app_repo.dart';

class FavouritePlaceCubit extends Cubit<bool> {
  final AppRepo appRepo;

  FavouritePlaceCubit({required this.appRepo}) : super(false);

  void favouritePlace(PlaceEntity placeEntity) async {
    if (!state) {
      await appRepo.favouritePlace(placeEntity, true);
    } else {
      await appRepo.favouritePlace(placeEntity, false);
    }

    emit(!state);
  }

  void getFavouritePlace(String placeId) async {
    final placesEither = await appRepo.getFavouritePlace();

    final places = placesEither.getOrElse(() => []);

    for (var data in places) {
      if (data.placeId == placeId && data.isFavourite) {
        emit(true);
        return;
      }
    }

    emit(false);
  }
}
