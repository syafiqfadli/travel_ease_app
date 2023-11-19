import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:travel_ease_app/src/core/app/presentation/widgets/column_builder.dart';
import 'package:travel_ease_app/src/core/utils/constants.dart';
import 'package:travel_ease_app/src/features/app/core/domain/entities/place/place_entity.dart';

class HasDetails extends StatelessWidget {
  final PlaceEntity place;

  const HasDetails({super.key, required this.place});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              color: PrimaryColor.navyBlack,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 5,
              ),
              child: AutoSizeText(
                place.placeName,
                style: TextStyle(color: PrimaryColor.pureWhite, fontSize: 16),
              ),
            ),
          ),
          const SizedBox(height: 10),
          place.address.isNotEmpty
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.room),
                    const SizedBox(width: 10),
                    Flexible(
                      child: AutoSizeText(place.address),
                    ),
                  ],
                )
              : const SizedBox.shrink(),
          Divider(color: PrimaryColor.navyBlack, height: 40),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              place.businessHours.isNotEmpty
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.access_time, size: 30),
                        const SizedBox(width: 10),
                        ColumnBuilder(
                          itemCount: place.businessHours.length,
                          itemBuilder: (context, index) {
                            return Text(place.businessHours[index]);
                          },
                        ),
                      ],
                    )
                  : const SizedBox.shrink(),
              place.phoneNo.isNotEmpty
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Icon(Icons.phone, size: 30),
                        const SizedBox(width: 10),
                        Text(place.phoneNo),
                      ],
                    )
                  : const SizedBox.shrink(),
            ],
          ),
        ],
      ),
    );
  }
}
