import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:travel_ease_app/src/core/utils/constants.dart';
import 'package:travel_ease_app/src/features/app/features/map/presentation/pages/map_page.dart';

class AddRoutePage extends StatefulWidget {
  const AddRoutePage({super.key});

  @override
  State<AddRoutePage> createState() => _AddRoutePageState();
}

class _AddRoutePageState extends State<AddRoutePage> {
  @override
  Widget build(BuildContext context) {
    const CameraPosition initPosition = CameraPosition(
      target: LatLng(2.1926, 102.2505),
      zoom: 14.45,
    );

    return WillPopScope(
      onWillPop: () {
        return Future.value(false);
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Add Route'),
          backgroundColor: PrimaryColor.navyBlack,
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            icon: const Icon(Icons.arrow_back_ios),
          ),
        ),
        body: const MapPage(
          isRoute: true,
          initPosition: initPosition,
        ),
      ),
    );
  }
}
