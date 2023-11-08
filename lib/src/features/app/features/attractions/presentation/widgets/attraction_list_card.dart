import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:travel_ease_app/src/core/app/presentation/widgets/column_builder.dart';
import 'package:travel_ease_app/src/core/utils/constants.dart';
import 'package:travel_ease_app/src/features/app/core/domain/entities/place/place_entity.dart';

class AttractionListCard extends StatelessWidget {
  final PlaceEntity place;

  const AttractionListCard({
    super.key,
    required this.place,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Container(
        color: PrimaryColor.navyBlack,
        child: Card(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: AutoSizeText(
                      place.placeName,
                      maxFontSize: 22,
                      minFontSize: 20,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Rating',
                      style: TextStyle(decoration: TextDecoration.underline),
                    ),
                    Text(
                      place.rating.toStringAsFixed(1),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Prices',
                      style: TextStyle(decoration: TextDecoration.underline),
                    ),
                    const SizedBox(height: 5),
                    place.prices.isEmpty
                        ? const Text('N/A')
                        : Row(
                            children: [
                              ColumnBuilder(
                                itemCount: place.prices.length,
                                itemBuilder: (context, index) {
                                  final String category =
                                      place.prices[index].category;

                                  return Text(
                                    "$category: ",
                                  );
                                },
                              ),
                              ColumnBuilder(
                                itemCount: place.prices.length,
                                itemBuilder: (context, index) {
                                  final double price =
                                      place.prices[index].price;

                                  return Text(
                                    "RM${price.toStringAsFixed(2)}",
                                  );
                                },
                              ),
                            ],
                          )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
