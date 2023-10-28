import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:travel_ease_app/src/core/utils/constants.dart';
import 'package:travel_ease_app/src/features/app/core/domain/entities/place/place_entity.dart';
import 'package:travel_ease_app/src/features/app/features/near_me/presentation/widgets/column_builder.dart';

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
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "ADDRESS: ",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Flexible(
                child: AutoSizeText(place.address),
              ),
            ],
          ),
          Divider(color: PrimaryColor.navyBlack, height: 40),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
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
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(Icons.phone, size: 30),
                  const SizedBox(width: 10),
                  Text(place.phoneNo),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
