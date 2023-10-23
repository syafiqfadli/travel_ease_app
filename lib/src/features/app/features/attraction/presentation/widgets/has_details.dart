import 'package:flutter/material.dart';
import 'package:travel_ease_app/src/features/app/core/domain/entities/place/place_entity.dart';

class HasDetails extends StatelessWidget {
  final PlaceEntity place;

  const HasDetails({super.key, required this.place});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(place.placeName),
        Text(place.address),
        Text(place.phoneNo),
      ],
    );
  }
}
