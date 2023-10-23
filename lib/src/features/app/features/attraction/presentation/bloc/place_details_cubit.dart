import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:travel_ease_app/src/features/app/core/domain/entities/place/place_entity.dart';
import 'package:travel_ease_app/src/features/app/core/domain/repositories/app_repo.dart';

part 'place_details_state.dart';

class PlaceDetailsCubit extends Cubit<PlaceDetailsState> {
  final AppRepo appRepo;

  PlaceDetailsCubit({required this.appRepo}) : super(PlaceDetailsInitial());

  void getPlaceDetails(String placeId) async {
    emit(PlaceDetailsLoading());

    final placesEither = await appRepo.getPlacesFromStorage();

    final places = placesEither.getOrElse(() => []);

    if (places.isNotEmpty) {
      for (var data in places) {
        if (data.placeId == placeId) {
          emit(PlaceDetailsLoaded(place: data));
          return;
        }
      }
    }

    final placeEither = await appRepo.placeDetails(placeId);

    placeEither.fold(
      (failure) => emit(PlaceDetailsError(message: failure.message)),
      (place) => emit(PlaceDetailsLoaded(place: place)),
    );
  }
}
