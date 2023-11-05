import 'package:bloc/bloc.dart';
import 'package:travel_ease_app/src/features/app/core/domain/entities/place/place_entity.dart';

class PlacePricesCubit extends Cubit<List<PlaceEntity>> {
  PlacePricesCubit() : super([]);

  void getPlacePrices(List<PlaceEntity> place) async {
    emit(place);
  }
}
