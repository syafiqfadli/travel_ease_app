import 'package:bloc/bloc.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:travel_ease_app/src/features/app/core/domain/entities/place/place_entity.dart';

class OpenMapCubit extends Cubit<List<AvailableMap>> {
  OpenMapCubit() : super([]);

  Future<void> showAvailableMaps() async {
    final mapList = await MapLauncher.installedMaps;

    emit(mapList);
  }

  void openMap(PlaceEntity place, int index) async {
    await MapLauncher.showMarker(
      mapType: state[index].mapType,
      coords: Coords(
        place.location.latitude,
        place.location.longitude,
      ),
      title: place.placeName,
    );
  }
}
