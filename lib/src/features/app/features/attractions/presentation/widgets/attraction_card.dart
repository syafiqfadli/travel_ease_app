import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:travel_ease_app/src/core/utils/constants.dart';
import 'package:travel_ease_app/src/features/app/features/attractions/presentation/pages/attraction_list_page.dart';

class AttractionCard extends StatelessWidget {
  final String placeName;
  final String image;

  const AttractionCard({
    super.key,
    required this.placeName,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => AttractionListPage(
              placeName: placeName,
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
                    'assets/images/places/$placeName/$image',
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
                      placeName,
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
