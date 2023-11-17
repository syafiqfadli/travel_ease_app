import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:travel_ease_app/src/core/app/presentation/widgets/column_builder.dart';
import 'package:travel_ease_app/src/core/utils/constants.dart';
import 'package:travel_ease_app/src/core/utils/helpers.dart';
import 'package:travel_ease_app/src/features/app/core/domain/entities/place/direction_entity.dart';

class RouteResultCard extends StatelessWidget {
  final String mode;
  final Map<String, double> cost;
  final DirectionEntity? direction;

  const RouteResultCard({
    super.key,
    required this.mode,
    required this.cost,
    this.direction,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
        decoration: BoxDecoration(
          border: Border.all(color: PrimaryColor.navyBlack),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Icon(
              mode == 'car'
                  ? Icons.drive_eta
                  : mode == 'motor'
                      ? Icons.motorcycle
                      : Icons.directions_walk,
              size: 40,
            ),
            SizedBox(
              width: 250,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _totalItem('Cost/Pax: ', cost),
                  const SizedBox(height: 10),
                  _directionItem(
                    'Total Duration:  ',
                    direction == null
                        ? 'N/A'
                        : TimeHelper.convertSecondsToTime(direction!.duration),
                  ),
                  _directionItem(
                    'Total Distance:  ',
                    direction == null
                        ? 'N/A'
                        : "${(direction!.distance / 1000).toStringAsFixed(1)} km",
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _directionItem(String title, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 16),
        ),
        Flexible(
          child: AutoSizeText(
            value,
            maxLines: 1,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _totalItem(String title, Map<String, double> cost) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 16),
        ),
        cost.isEmpty
            ? const Text(
                'N/A',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              )
            : ColumnBuilder(
                itemCount: cost.length,
                itemBuilder: (context, index) {
                  String category = cost.keys.elementAt(index);
                  double total = cost[category]!;

                  return SizedBox(
                    width: 120,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: AutoSizeText(
                            'RM${total.toStringAsFixed(2)}',
                            maxLines: 1,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Flexible(
                          child: AutoSizeText(
                            '($category)',
                            maxLines: 1,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
      ],
    );
  }
}
