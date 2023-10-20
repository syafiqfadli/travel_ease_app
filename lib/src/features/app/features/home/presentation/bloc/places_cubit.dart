import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:travel_ease_app/src/features/app/core/domain/entities/place/place_entity.dart';
import 'package:travel_ease_app/src/features/app/features/home/domain/repositories/home_repo.dart';

part 'places_state.dart';

class PlacesCubit extends Cubit<PlacesState> {
  final HomeRepo homeRepo;

  PlacesCubit({required this.homeRepo}) : super(PlacesInitial());

  void searchPlaces(String query) async {
    emit(PlacesLoading());

    final placesEither = await homeRepo.searchPlaces(query);

    placesEither.fold(
      (failure) => emit(PlacesError(message: failure.message)),
      (places) => emit(PlacesLoaded(places: places)),
    );
  }
}
