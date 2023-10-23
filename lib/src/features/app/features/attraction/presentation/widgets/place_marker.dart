import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travel_ease_app/src/features/app/core/domain/entities/place/place_entity.dart';
import 'package:travel_ease_app/src/features/app/features/attraction/presentation/bloc/place_details_cubit.dart';

class PlaceMarker extends StatelessWidget {
  final PlaceEntity place;
  final String location;

  const PlaceMarker({super.key, required this.place, required this.location});

  @override
  Widget build(BuildContext context) {
    double setLocationTop() {
      if (location == 'left') {
        return 40;
      }

      if (location == 'center') {
        return 270;
      }

      if (location == 'right') {
        return 150;
      }

      return 0;
    }

    double setLocationLeft() {
      if (location == 'left') {
        return 0;
      }

      if (location == 'center') {
        return 100;
      }

      if (location == 'right') {
        return 160;
      }

      return 0;
    }

    return Positioned(
      top: setLocationTop(),
      left: setLocationLeft(),
      child: Column(
        children: [
          IconButton(
            onPressed: () {
              context.read<PlaceDetailsCubit>().getPlaceDetails(place.placeId);
            },
            icon: const Icon(Icons.room, size: 40),
          ),
          Text(place.placeName),
        ],
      ),
    );
  }
}
