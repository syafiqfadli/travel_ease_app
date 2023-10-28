import 'package:flutter/widgets.dart';
import 'package:travel_ease_app/src/features/app/core/domain/entities/place/place_entity.dart';
import 'package:travel_ease_app/src/features/app/features/near_me/presentation/widgets/place_marker.dart';

class PlaceMarkerList extends StatelessWidget {
  final List<PlaceEntity> places;

  const PlaceMarkerList({super.key, required this.places});

  @override
  Widget build(BuildContext context) {
    String setLocation(int index) {
      if (index == 0) {
        return 'left';
      }

      if (index == 1) {
        return 'center';
      }

      if (index == 2) {
        return 'right';
      }

      return '';
    }

    double setLocationTop(String location) {
      if (location == 'left') {
        return 40;
      }

      if (location == 'center') {
        return 200;
      }

      if (location == 'right') {
        return 100;
      }

      return 0;
    }

    double setLocationLeft(String location) {
      if (location == 'left') {
        return 0;
      }

      if (location == 'center') {
        return 80;
      }

      if (location == 'right') {
        return 180;
      }

      return 0;
    }

    return SizedBox(
      height: 300,
      child: Stack(
        children: List.generate(places.length, (index) {
          final place = places[index];
          final location = setLocation(index);

          return Positioned(
            left: setLocationLeft(location),
            top: setLocationTop(location),
            child: PlaceMarker(place: place, location: location),
          );
        }),
      ),
    );
  }
}
