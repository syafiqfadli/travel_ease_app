import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:travel_ease_app/src/features/app/core/domain/entities/place/place_entity.dart';
import 'package:travel_ease_app/src/features/app/core/domain/repositories/app_repo.dart';

part 'search_places_state.dart';

class SearchPlacesCubit extends Cubit<SearchPlacesState> {
  final AppRepo appRepo;

  SearchPlacesCubit({required this.appRepo}) : super(SearchPlacesInitial());

  void searchPlaces(String query) async {
    emit(SearchPlacesLoading());

    final placesEither = await appRepo.searchPlaces(query);

    placesEither.fold(
      (failure) => emit(SearchPlacesError(message: failure.message)),
      (places) => emit(SearchPlacesLoaded(places: places)),
    );
  }

  void clearSearch() {
    emit(SearchPlacesInitial());
  }
}
