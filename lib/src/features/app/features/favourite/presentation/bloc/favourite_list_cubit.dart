import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:travel_ease_app/src/features/app/core/domain/entities/place/place_entity.dart';
import 'package:travel_ease_app/src/features/app/core/domain/repositories/app_repo.dart';

part 'favourite_list_state.dart';

class FavouriteListCubit extends Cubit<FavouriteListState> {
  final AppRepo appRepo;

  FavouriteListCubit({required this.appRepo}) : super(FavouriteInitial());

  void getFavouritePlaces() async {
    final placesEither = await appRepo.getFavouritePlace();

    final places = placesEither.getOrElse(() => []);

    emit(FavouriteLoaded(places: places));
  }
}
