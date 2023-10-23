import 'package:bloc/bloc.dart';
import 'package:travel_ease_app/src/features/app/core/domain/entities/place/place_entity.dart';

class SelectPlaceCubit extends Cubit<PlaceEntity?> {
  SelectPlaceCubit() : super(null);

  void placeSelected(PlaceEntity place) {
    emit(place);
  }

  void removePlace() {
    emit(null);
  }
}
