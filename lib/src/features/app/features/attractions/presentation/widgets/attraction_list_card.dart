import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:travel_ease_app/src/core/utils/constants.dart';
import 'package:travel_ease_app/src/features/app/core/domain/entities/place/place_entity.dart';
import 'package:travel_ease_app/src/features/app/features/attractions/presentation/pages/attraction_details_page.dart';

class AttractionListCard extends StatelessWidget {
  final String attractionName;
  final PlaceEntity place;

  const AttractionListCard({
    super.key,
    required this.attractionName,
    required this.place,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => AttractionDetailsPage(
              attractionName: attractionName,
              place: place,
            ),
          ));
        },
        child: Container(
          color: PrimaryColor.navyBlack,
          child: Card(
            child: Column(
              children: [
                SizedBox(
                  height: 180,
                  child: Image.asset(
                    'assets/images/places/$attractionName/${place.placeName} - ${place.placeId}/1.png',
                    fit: BoxFit.fill,
                  ),
                ),
                const SizedBox(height: 15),
                Flexible(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(15),
                      ),
                      color: PrimaryColor.navyBlack,
                    ),
                    padding: const EdgeInsets.symmetric(
                      vertical: 5,
                      horizontal: 15,
                    ),
                    margin: const EdgeInsets.symmetric(horizontal: 5),
                    child: AutoSizeText(
                      place.placeName,
                      style: TextStyle(
                        color: PrimaryColor.pureWhite,
                      ),
                      maxFontSize: 16,
                      minFontSize: 14,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
