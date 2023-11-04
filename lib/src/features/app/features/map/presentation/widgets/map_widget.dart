import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:travel_ease_app/src/features/app/features/map/presentation/bloc/marker_list_cubit.dart';
import 'package:travel_ease_app/src/features/app/features/map/presentation/bloc/polyline_list_cubit.dart';

class MapWidget extends StatelessWidget {
  final Completer<GoogleMapController> googleController;
  final CameraPosition initPosition;
  final bool isRoute;

  const MapWidget({
    super.key,
    required this.googleController,
    required this.initPosition,
    required this.isRoute,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MarkerListCubit, List<Marker>>(
      builder: (context, markers) {
        return BlocBuilder<PolylineListCubit, List<Polyline>>(
          builder: (context, polylines) {
            return GoogleMap(
              mapType: MapType.normal,
              initialCameraPosition: initPosition,
              markers: Set.from(markers),
              polylines: Set.from(isRoute ? polylines : []),
              onMapCreated: (GoogleMapController controller) {
                googleController.complete(controller);
              },
              onTap: (_) {
                FocusManager.instance.primaryFocus?.unfocus();
              },
            );
          },
        );
      },
    );
  }
}
