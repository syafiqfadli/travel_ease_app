import 'package:bloc/bloc.dart';
import 'package:travel_ease_app/src/features/app/core/domain/entities/place/place_entity.dart';

class PlaceListCubit extends Cubit<List<PlaceEntity>> {
  PlaceListCubit() : super([]);

  void addPlace(PlaceEntity place) {
    final updatedList = [...state, place];

    emit(updatedList);
  }

  void clearList() {
    emit([]);
  }
}
