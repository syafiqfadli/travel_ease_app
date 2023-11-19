import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:travel_ease_app/src/core/app/presentation/widgets/column_builder.dart';
import 'package:travel_ease_app/src/core/app/presentation/widgets/loading.dart';
import 'package:travel_ease_app/src/core/utils/constants.dart';
import 'package:travel_ease_app/src/features/app/app_injector.dart';
import 'package:travel_ease_app/src/features/app/core/domain/entities/place/place_entity.dart';
import 'package:travel_ease_app/src/features/app/features/attractions/presentation/bloc/attraction_details_cubit.dart';
import 'package:travel_ease_app/src/features/app/features/attractions/presentation/widgets/image_slider.dart';
import 'package:travel_ease_app/src/features/app/features/attractions/presentation/widgets/item_details.dart';

class AttractionDetailsPage extends StatefulWidget {
  final String attractionName;
  final PlaceEntity place;

  const AttractionDetailsPage({
    super.key,
    required this.attractionName,
    required this.place,
  });

  @override
  State<AttractionDetailsPage> createState() => _AttractionDetailsPageState();
}

class _AttractionDetailsPageState extends State<AttractionDetailsPage> {
  final AttractionDetailsCubit attractionDetailsCubit =
      appInjector<AttractionDetailsCubit>();

  @override
  void initState() {
    super.initState();
    attractionDetailsCubit.getPlaceDetails(widget.place.placeId);
  }

  @override
  Widget build(BuildContext context) {
    final List<String> images = [
      'assets/images/places/${widget.attractionName}/${widget.place.placeName} - ${widget.place.placeId}/1.png',
      'assets/images/places/${widget.attractionName}/${widget.place.placeName} - ${widget.place.placeId}/2.png',
      'assets/images/places/${widget.attractionName}/${widget.place.placeName} - ${widget.place.placeId}/3.png',
    ];

    return BlocProvider.value(
      value: attractionDetailsCubit,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: PrimaryColor.navyBlack,
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.arrow_back_ios),
          ),
          title: const Text('Details'),
          centerTitle: true,
        ),
        body: BlocBuilder<AttractionDetailsCubit, AttractionDetailsState>(
          builder: (context, state) {
            if (state is AttractionDetailsLoading) {
              return const CustomLoading();
            }

            if (state is AttractionDetailsLoaded) {
              final place = state.place;

              return SingleChildScrollView(
                child: Column(
                  children: [
                    ImageSlider(images: images),
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AutoSizeText(
                            place.placeName,
                            minFontSize: 25,
                            maxLines: 2,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 30,
                            ),
                          ),
                          Row(
                            children: [
                              Text(place.rating.toStringAsFixed(1)),
                              RatingBar.builder(
                                initialRating: place.rating,
                                direction: Axis.horizontal,
                                allowHalfRating: true,
                                itemCount: 5,
                                itemSize: 20,
                                itemPadding: const EdgeInsets.symmetric(
                                  horizontal: 4.0,
                                ),
                                itemBuilder: (context, _) => const Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                ),
                                onRatingUpdate: (_) {},
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          place.address.isNotEmpty
                              ? ItemDetails(
                                  icon: Icons.room,
                                  item: Text(
                                    place.address,
                                    overflow: TextOverflow.visible,
                                  ),
                                )
                              : const SizedBox.shrink(),
                          place.businessHours.isNotEmpty
                              ? ItemDetails(
                                  icon: Icons.access_time,
                                  item: ColumnBuilder(
                                    itemCount: place.businessHours.length,
                                    itemBuilder: (context, index) {
                                      final parts = place.businessHours[index]
                                          .split(': ');
                                      final day = parts[0];
                                      final time = parts[1];

                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 5,
                                        ),
                                        child: Row(
                                          children: [
                                            SizedBox(
                                              width: 100,
                                              child: Text('$day:'),
                                            ),
                                            Text(time)
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                )
                              : const SizedBox.shrink(),
                          place.phoneNo.isNotEmpty
                              ? ItemDetails(
                                  icon: Icons.phone,
                                  item: Text(place.phoneNo),
                                )
                              : const SizedBox.shrink(),
                          place.prices.isNotEmpty
                              ? ItemDetails(
                                  icon: Icons.money,
                                  item: ColumnBuilder(
                                    itemCount: place.prices.length,
                                    itemBuilder: (context, index) {
                                      final price = place.prices[index];

                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 5,
                                        ),
                                        child: Row(
                                          children: [
                                            SizedBox(
                                              width: 100,
                                              child: Text('${price.category}:'),
                                            ),
                                            Text(
                                              'RM ${price.price.toStringAsFixed(2)}',
                                            )
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                )
                              : const SizedBox.shrink(),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
