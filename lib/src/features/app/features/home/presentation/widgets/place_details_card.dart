import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:travel_ease_app/src/core/utils/constants.dart';
import 'package:travel_ease_app/src/features/app/core/domain/entities/place/place_entity.dart';
import 'package:travel_ease_app/src/features/app/features/home/presentation/bloc/select_place_cubit.dart';

class PlaceDetailsCard extends StatelessWidget {
  final PlaceEntity place;
  final Completer<GoogleMapController> completerController;

  const PlaceDetailsCard({
    super.key,
    required this.place,
    required this.completerController,
  });

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;

    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 20,
      ),
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          color: PrimaryColor.pureWhite,
        ),
        height: 150,
        width: width - 80,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(place.placeName),
            Text(
                'Location: ${place.location.longitude}, ${place.location.latitude}'),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () async {
                    final GoogleMapController controller =
                        await completerController.future;
                    await controller.animateCamera(
                      CameraUpdate.newCameraPosition(
                        CameraPosition(
                          target: LatLng(
                            place.location.latitude,
                            place.location.longitude,
                          ),
                          zoom: 14.4746,
                        ),
                      ),
                    );
                  },
                  child: const Text('Go!'),
                ),
                ElevatedButton(
                  onPressed: () {
                    context.read<SelectPlaceCubit>().removePlace();
                  },
                  child: const Text('Close'),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
