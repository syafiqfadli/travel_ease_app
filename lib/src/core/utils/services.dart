import 'package:flutter/material.dart';
import 'package:travel_ease_app/src/core/app/presentation/widgets/column_builder.dart';
import 'package:travel_ease_app/src/core/utils/constants.dart';
import 'package:travel_ease_app/src/features/app/core/domain/entities/place/place_entity.dart';
import 'package:travel_ease_app/src/features/app/features/map/presentation/pages/route_page.dart';

class DialogService {
  static Future showMessage<T>({
    required String title,
    required bool hasAction,
    void Function()? actionFunction,
    String? message,
    required IconData icon,
    required BuildContext context,
  }) async {
    double width = MediaQuery.of(context).size.width;

    return showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Column(
          children: [
            Icon(icon, size: 45),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Text(
                title,
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ),
          ],
        ),
        content: message != null
            ? Text(
                message,
                textAlign: TextAlign.center,
              )
            : null,
        actions: [
          SizedBox(
            width: width,
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: PrimaryColor.navyBlack,
              ),
              child: const Text('Close'),
            ),
          ),
          hasAction
              ? SizedBox(
                  width: width,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const RoutePage(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      foregroundColor: PrimaryColor.navyBlack,
                      backgroundColor: PrimaryColor.pureWhite,
                      side: BorderSide(color: PrimaryColor.navyBlack),
                    ),
                    child: const Text('View'),
                  ),
                )
              : const SizedBox.shrink(),
        ],
      ),
    );
  }

  static Future showPlacesPrice<T>({
    required BuildContext context,
    required List<PlaceEntity> places,
  }) async {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Planned Destinations"),
        content: SizedBox(
          height: height * 0.5,
          child: SingleChildScrollView(
            child: ColumnBuilder(
              itemCount: places.length,
              itemBuilder: (context, placeIndex) {
                return Container(
                  width: width,
                  padding: const EdgeInsets.all(20),
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    border: Border.all(color: PrimaryColor.navyBlack),
                    borderRadius: const BorderRadius.all(Radius.circular(15)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        places[placeIndex].placeName,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      places[placeIndex].prices.isEmpty
                          ? const Text('N/A')
                          : Row(
                              children: [
                                ColumnBuilder(
                                  itemCount: places[placeIndex].prices.length,
                                  itemBuilder: (context, index) {
                                    final String category = places[placeIndex]
                                        .prices[index]
                                        .category;

                                    return Text("$category: ");
                                  },
                                ),
                                ColumnBuilder(
                                  itemCount: places[placeIndex].prices.length,
                                  itemBuilder: (context, index) {
                                    final double price =
                                        places[placeIndex].prices[index].price;

                                    return Text(
                                        "RM${price.toStringAsFixed(2)} ");
                                  },
                                ),
                              ],
                            )
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
