import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:travel_ease_app/src/features/app/features/map/presentation/bloc/marker_list_cubit.dart';
import 'package:travel_ease_app/src/features/app/features/map/presentation/bloc/polyline_list_cubit.dart';

class MapWidget extends StatefulWidget {
  final CameraPosition initPosition;
  final bool isRoute;

  const MapWidget({
    super.key,
    required this.initPosition,
    required this.isRoute,
  });

  @override
  State<MapWidget> createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  late GoogleMapController? googleController;

  @override
  void dispose() {
    super.dispose();
    googleController!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MarkerListCubit, List<Marker>>(
      builder: (context, markers) {
        return BlocBuilder<PolylineListCubit, List<Polyline>>(
          builder: (context, polylines) {
            return GoogleMap(
              mapType: MapType.normal,
              initialCameraPosition: widget.initPosition,
              markers: Set.from(widget.isRoute ? markers : []),
              polylines: Set.from(widget.isRoute ? polylines : []),
              onMapCreated: _onMapCreated,
              onTap: (_) {
                FocusManager.instance.primaryFocus?.unfocus();
              },
            );
          },
        );
      },
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    googleController = controller;
  }
}
