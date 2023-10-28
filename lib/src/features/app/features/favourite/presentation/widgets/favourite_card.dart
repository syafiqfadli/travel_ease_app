import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travel_ease_app/src/core/utils/constants.dart';
import 'package:travel_ease_app/src/features/app/core/domain/entities/place/place_entity.dart';
import 'package:travel_ease_app/src/features/app/features/favourite/presentation/bloc/favourite_list_cubit.dart';

class FavouriteCard extends StatelessWidget {
  final PlaceEntity place;

  const FavouriteCard({super.key, required this.place});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: AutoSizeText(
                  place.placeName,
                  maxLines: 2,
                  minFontSize: 14,
                  style: const TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
              IconButton(
                onPressed: () {
                  context.read<FavouriteListCubit>().removeFavourite(place);
                },
                icon: Icon(
                  Icons.favorite,
                  color: PrimaryColor.pureRed,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
