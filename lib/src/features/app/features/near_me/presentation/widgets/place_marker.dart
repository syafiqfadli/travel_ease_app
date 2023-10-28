import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travel_ease_app/src/features/app/core/domain/entities/place/place_entity.dart';
import 'package:travel_ease_app/src/features/app/features/near_me/presentation/bloc/place_details_cubit.dart';

class PlaceMarker extends StatelessWidget {
  final PlaceEntity place;
  final String location;

  const PlaceMarker({super.key, required this.place, required this.location});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        IconButton(
          onPressed: () {
            context.read<PlaceDetailsCubit>().getPlaceDetails(place.placeId);
          },
          icon: const Icon(Icons.room, size: 40),
        ),
        SizedBox(
          width: 200,
          child: Text(
            place.placeName,
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
