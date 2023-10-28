import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travel_ease_app/src/features/app/core/domain/entities/place/place_entity.dart';
import 'package:travel_ease_app/src/features/app/features/map/presentation/bloc/select_place_cubit.dart';

class PlaceCard extends StatelessWidget {
  final PlaceEntity place;

  const PlaceCard({super.key, required this.place});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: InkWell(
        onTap: () {
          context.read<SelectPlaceCubit>().placeSelected(place);
        },
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Text(place.placeName),
          ),
        ),
      ),
    );
  }
}
