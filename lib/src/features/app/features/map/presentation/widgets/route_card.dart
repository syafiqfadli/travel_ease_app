import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travel_ease_app/src/core/utils/constants.dart';
import 'package:travel_ease_app/src/features/app/core/domain/entities/place/place_entity.dart';
import 'package:travel_ease_app/src/features/app/features/map/presentation/bloc/show_route_cubit.dart';

class RouteCard extends StatelessWidget {
  final int index;
  final PlaceEntity place;
  final bool isLastPlace;

  const RouteCard({
    super.key,
    required this.index,
    required this.place,
    required this.isLastPlace,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 80,
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: 250,
                    child: Row(
                      children: [
                        Text('${index + 1}'),
                        const SizedBox(width: 20),
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
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      context.read<ShowRouteCubit>().removeRoute(place);
                    },
                    icon: Icon(
                      Icons.cancel,
                      color: PrimaryColor.pureRed,
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        !isLastPlace
            ? const Icon(Icons.arrow_downward_rounded)
            : const SizedBox.shrink(),
      ],
    );
  }
}
