import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:travel_ease_app/src/features/app/app_injector.dart';
import 'package:travel_ease_app/src/features/app/features/map/presentation/bloc/marker_list_cubit.dart';
import 'package:travel_ease_app/src/features/app/features/map/presentation/bloc/polyline_list_cubit.dart';

class MapWidget extends StatefulWidget {
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
  State<MapWidget> createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  final MarkerListCubit markerListCubit = appInjector<MarkerListCubit>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: markerListCubit,
      child: BlocBuilder<MarkerListCubit, List<Marker>>(
        builder: (context, markers) {
          return BlocBuilder<PolylineListCubit, List<Polyline>>(
            builder: (context, polylines) {
              return GoogleMap(
                mapType: MapType.normal,
                initialCameraPosition: widget.initPosition,
                markers: Set.from(markers),
                polylines: Set.from(widget.isRoute ? polylines : []),
                onMapCreated: (GoogleMapController controller) {
                  widget.googleController.complete(controller);
                  markerListCubit.getMarkerList();
                },
                onTap: (_) {
                  FocusManager.instance.primaryFocus?.unfocus();
                },
              );
            },
          );
        },
      ),
    );
  }
}
