import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:travel_ease_app/src/core/utils/constants.dart';
import 'package:travel_ease_app/src/core/utils/helper.dart';
import 'package:travel_ease_app/src/features/app/core/domain/entities/place/direction_entity.dart';

class CalculateResultCard extends StatelessWidget {
  final String mode;
  final double cost;
  final DirectionEntity? direction;

  const CalculateResultCard({
    super.key,
    required this.mode,
    required this.cost,
    this.direction,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Container(
        height: 150,
        decoration: BoxDecoration(
          border: Border.all(color: PrimaryColor.navyBlack),
          borderRadius: const BorderRadius.all(Radius.circular(30)),
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
              width: 220,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  item(
                    'Average Cost: ',
                    "RM ${((cost * 10).roundToDouble() / 10).toStringAsFixed(2)}",
                  ),
                  item(
                    'Total Duration:  ',
                    direction == null
                        ? 'N/A'
                        : TimeHelper.convertSecondsToTime(direction!.duration),
                  ),
                  item(
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

  Widget item(String title, String value) {
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
}
