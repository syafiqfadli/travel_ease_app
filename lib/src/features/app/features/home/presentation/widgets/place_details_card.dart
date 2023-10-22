import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:travel_ease_app/src/core/utils/constants.dart';
import 'package:travel_ease_app/src/features/app/core/domain/entities/place/place_entity.dart';
import 'package:travel_ease_app/src/features/app/features/home/presentation/bloc/favourite_place_cubit.dart';
import 'package:travel_ease_app/src/features/app/features/home/presentation/bloc/select_place_cubit.dart';

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
  final FavouritePlaceCubit favouritePlaceCubit = FavouritePlaceCubit();

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;

    return BlocProvider(
      create: (context) => favouritePlaceCubit,
      child: Padding(
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
                  IconButton(
                    onPressed: () {
                      favouritePlaceCubit.favouritePlace();
                    },
                    icon: BlocBuilder<FavouritePlaceCubit, bool>(
                      builder: (context, isFavourite) {
                        return Icon(
                          isFavourite
                              ? Icons.favorite_rounded
                              : Icons.favorite_outline,
                          color: PrimaryColor.pureRed,
                        );
                      },
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      context.read<SelectPlaceCubit>().removePlace();
                    },
                    icon: const Icon(Icons.cancel),
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () => _goToPlace(),
                    style: ElevatedButton.styleFrom(
                      fixedSize: const Size(120, 20),
                      backgroundColor: PrimaryColor.navyBlack,
                    ),
                    child: const Text('Go'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      context.read<SelectPlaceCubit>().removePlace();
                    },
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      fixedSize: const Size(120, 20),
                      foregroundColor: PrimaryColor.navyBlack,
                      backgroundColor: PrimaryColor.pureWhite,
                      side: BorderSide(color: PrimaryColor.navyBlack),
                    ),
                    child: const Text('Add'),
                  )
                ],
              ),
            ],
          ),
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
          zoom: 14.4746,
        ),
      ),
    );
  }
}
