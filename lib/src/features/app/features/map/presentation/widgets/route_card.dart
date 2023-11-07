import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travel_ease_app/src/core/app/presentation/widgets/column_builder.dart';
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
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('${index + 1}'),
                SizedBox(
                  width: 250,
                  height: 100,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
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
                      const SizedBox(height: 10),
                      ColumnBuilder(
                        itemCount: place.prices.length,
                        itemBuilder: (context, priceIndex) {
                          final String category =
                              place.prices[priceIndex].category;
                          final double price = place.prices[priceIndex].price;

                          return Row(
                            children: [
                              Text("$category: "),
                              Text("RM${price.toStringAsFixed(2)} "),
                            ],
                          );
                        },
                      )
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
        !isLastPlace
            ? const Icon(Icons.arrow_downward_rounded)
            : const SizedBox.shrink(),
      ],
    );
  }
}
