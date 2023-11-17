import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travel_ease_app/src/core/utils/constants.dart';
import 'package:travel_ease_app/src/core/utils/services.dart';
import 'package:travel_ease_app/src/features/app/core/domain/entities/place/place_entity.dart';
import 'package:travel_ease_app/src/features/app/features/map/presentation/bloc/place_list_cubit.dart';
import 'package:travel_ease_app/src/features/app/features/map/presentation/bloc/search_places_cubit.dart';
import 'package:travel_ease_app/src/features/app/features/map/presentation/bloc/select_place_cubit.dart';
import 'package:travel_ease_app/src/features/app/features/map/presentation/pages/route_page.dart';

class PlaceDetailsCard extends StatefulWidget {
  final PlaceEntity place;
  final bool isRoute;

  const PlaceDetailsCard({
    super.key,
    required this.place,
    required this.isRoute,
  });

  @override
  State<PlaceDetailsCard> createState() => _PlaceDetailsCardState();
}

class _PlaceDetailsCardState extends State<PlaceDetailsCard> {
  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;

    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 20,
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          color: PrimaryColor.pureWhite,
        ),
        height: 150,
        width: width - 80,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: AutoSizeText(
                    widget.place.placeName,
                    maxFontSize: 16,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Row(
                  children: [
                    BlocBuilder<SelectPlaceCubit, PlaceEntity?>(
                      builder: (context, state) {
                        return IconButton(
                          onPressed: _favouritePlace,
                          icon: Icon(
                            state!.isFavourite
                                ? Icons.favorite_rounded
                                : Icons.favorite_outline,
                            color: PrimaryColor.pureRed,
                          ),
                        );
                      },
                    ),
                    IconButton(
                      onPressed: () {
                        context.read<SelectPlaceCubit>().removePlace();
                      },
                      icon: const Icon(Icons.cancel),
                    )
                  ],
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                (widget.isRoute)
                    ? ElevatedButton(
                        onPressed: _addNewPlace,
                        style: ElevatedButton.styleFrom(
                          fixedSize: const Size(120, 20),
                          backgroundColor: PrimaryColor.navyBlack,
                        ),
                        child: const Text('Add'),
                      )
                    : ElevatedButton(
                        onPressed: _navigateToRoutePage,
                        style: ElevatedButton.styleFrom(
                          fixedSize: const Size(120, 20),
                          backgroundColor: PrimaryColor.navyBlack,
                        ),
                        child: const Text('Go'),
                      ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToRoutePage() async {
    context.read<SearchPlacesCubit>().clearSearch();
    context.read<PlaceListCubit>().addPlace(widget.place);

    Navigator.of(context).pushReplacement(MaterialPageRoute(
      builder: (context) => const RoutePage(),
    ));
  }

  void _addNewPlace() {
    final places = context.read<PlaceListCubit>().state;
    final hasAdded =
        places.any((place) => place.placeId == widget.place.placeId);

    if (hasAdded) {
      DialogService.showMessage(
        context: context,
        title: 'Place already added.',
        icon: Icons.warning,
      );

      return;
    }

    context.read<PlaceListCubit>().addPlace(widget.place);
    Navigator.of(context).pop(true);
  }

  void _favouritePlace() {
    context.read<SelectPlaceCubit>().setFavouritePlace(widget.place);
  }
}
