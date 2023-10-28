import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:travel_ease_app/src/features/app/core/domain/entities/place/place_entity.dart';
import 'package:travel_ease_app/src/features/app/features/map/domain/repositories/map_repo.dart';

part 'search_places_state.dart';

class SearchPlacesCubit extends Cubit<SearchPlacesState> {
  final MapRepo mapRepo;

  SearchPlacesCubit({required this.mapRepo}) : super(SearchPlacesInitial());

  void searchPlaces(String query) async {
    emit(SearchPlacesLoading());

    final placesEither = await mapRepo.searchGooglePlaces(query);

    placesEither.fold(
      (failure) => emit(SearchPlacesError(message: failure.message)),
      (places) => emit(SearchPlacesLoaded(places: places)),
    );
  }

  void clearSearch() {
    emit(SearchPlacesInitial());
  }
}
