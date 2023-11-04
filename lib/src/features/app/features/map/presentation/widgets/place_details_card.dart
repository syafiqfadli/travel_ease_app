import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:travel_ease_app/src/core/utils/constants.dart';
import 'package:travel_ease_app/src/core/utils/services.dart';
import 'package:travel_ease_app/src/features/app/core/domain/entities/place/place_entity.dart';
import 'package:travel_ease_app/src/features/app/features/map/presentation/bloc/marker_list_cubit.dart';
import 'package:travel_ease_app/src/features/app/features/map/presentation/bloc/select_place_cubit.dart';

class PlaceDetailsCard extends StatefulWidget {
  final PlaceEntity place;
  final Completer<GoogleMapController> completerController;

  const PlaceDetailsCard({
    super.key,
    required this.place,
    required this.completerController,
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
                ElevatedButton(
                  onPressed: _goToPlace,
                  style: ElevatedButton.styleFrom(
                    fixedSize: const Size(120, 20),
                    backgroundColor: PrimaryColor.navyBlack,
                  ),
                  child: const Text('Go'),
                ),
                BlocBuilder<SelectPlaceCubit, PlaceEntity?>(
                  builder: (context, place) {
                    return ElevatedButton(
                      onPressed: place!.hasMarker
                          ? _removePlaceMarker
                          : _addPlaceMarker,
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        fixedSize: const Size(120, 20),
                        foregroundColor: PrimaryColor.navyBlack,
                        backgroundColor: PrimaryColor.pureWhite,
                        side: BorderSide(color: PrimaryColor.navyBlack),
                      ),
                      child: Text(place.hasMarker ? 'Remove' : 'Add'),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _goToPlace() async {
    final GoogleMapController controller =
        await widget.completerController.future;

    await controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(
            widget.place.location.latitude,
            widget.place.location.longitude,
          ),
          zoom: 14.45,
        ),
      ),
    );
  }

  void _favouritePlace() {
    context.read<SelectPlaceCubit>().setFavouritePlace(widget.place);
  }

  void _addPlaceMarker() {
    if (context.read<MarkerListCubit>().state.length == 4) {
      DialogService.showMessage(
        title: 'Limit reached.',
        message: "You can only add place to route only up to 4 only.",
        hasAction: false,
        icon: Icons.warning,
        context: context,
      );

      return;
    }

    context.read<MarkerListCubit>().addMarker(widget.place);
    context.read<SelectPlaceCubit>().setMarker(widget.place);

    _goToPlace();
  }

  void _removePlaceMarker() {
    context.read<MarkerListCubit>().removeMarker(widget.place.placeId);
    context.read<SelectPlaceCubit>().setMarker(widget.place);
  }
}
