import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:travel_ease_app/src/core/utils/constants.dart';
import 'package:travel_ease_app/src/features/app/app_injector.dart';
import 'package:travel_ease_app/src/features/app/core/domain/entities/place/place_entity.dart';
import 'package:travel_ease_app/src/features/app/features/map/presentation/bloc/marker_list_cubit.dart';
import 'package:travel_ease_app/src/features/app/features/map/presentation/bloc/polyline_list_cubit.dart';
import 'package:travel_ease_app/src/features/app/features/map/presentation/bloc/show_route_cubit.dart';
import 'package:travel_ease_app/src/features/app/features/map/presentation/pages/calculate_page.dart';
import 'package:travel_ease_app/src/features/app/features/map/presentation/widgets/map_widget.dart';
import 'package:travel_ease_app/src/features/app/features/map/presentation/widgets/route_card.dart';

class RoutePage extends StatefulWidget {
  const RoutePage({super.key});

  @override
  State<RoutePage> createState() => _RoutePageState();
}

class _RoutePageState extends State<RoutePage> {
  final ShowRouteCubit showRouteCubit = appInjector<ShowRouteCubit>();
  final MarkerListCubit markerListCubit = appInjector<MarkerListCubit>();
  final PolylineListCubit polylineListCubit = appInjector<PolylineListCubit>();

  final Completer<GoogleMapController> googleController =
      Completer<GoogleMapController>();

  @override
  void initState() {
    super.initState();
    showRouteCubit.getRouteList();
  }

  @override
  void dispose() {
    super.dispose();
    showRouteCubit.reset();
  }

  @override
  Widget build(BuildContext context) {
    final height =
        MediaQuery.of(context).size.height - AppBar().preferredSize.height;

    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: showRouteCubit),
        BlocProvider.value(value: markerListCubit),
        BlocProvider.value(value: polylineListCubit),
      ],
      child: BlocListener<ShowRouteCubit, List<PlaceEntity>>(
        listener: (context, places) {
          if (places.length >= 2) {
            for (var i = 0; i < places.length; i++) {
              showRouteCubit.computePath(i);
            }
          }
        },
        child: WillPopScope(
          onWillPop: () {
            Navigator.of(context).pop(true);
            return Future.value(true);
          },
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: PrimaryColor.navyBlack,
              leading: IconButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                icon: const Icon(Icons.arrow_back_ios),
              ),
              title: const Text('VIEW ROUTES'),
              centerTitle: true,
            ),
            body: BlocBuilder<ShowRouteCubit, List<PlaceEntity>>(
              builder: (context, places) {
                if (places.isEmpty) {
                  return const Center(
                    child: Text("No route to show yet."),
                  );
                }

                if (places.isNotEmpty) {
                  CameraPosition initPosition = CameraPosition(
                    target: LatLng(
                      places[0].location.latitude,
                      places[0].location.longitude,
                    ),
                    zoom: 13,
                  );

                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(
                          height: height * 0.4,
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: ListView.builder(
                              itemCount: places.length,
                              itemBuilder: (context, index) {
                                final isLastPlace = index == places.length - 1;

                                return RouteCard(
                                  index: index,
                                  place: places[index],
                                  isLastPlace: isLastPlace,
                                );
                              },
                            ),
                          ),
                        ),
                        Divider(
                          color: PrimaryColor.navyBlack,
                          height: 20,
                          indent: 20,
                          endIndent: 20,
                        ),
                        SizedBox(
                          height: height * 0.5,
                          child: Stack(
                            children: [
                              MapWidget(
                                initPosition: initPosition,
                                isRoute: true,
                                googleController: googleController,
                              ),
                              Positioned(
                                top: 10,
                                left: 10,
                                child: Visibility(
                                  visible: places.length >= 2 ? true : false,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const CalculatePage(),
                                        ),
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      padding: const EdgeInsets.all(15),
                                      backgroundColor: PrimaryColor.navyBlack,
                                    ),
                                    child: const Text('Calculate'),
                                  ),
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  );
                }

                return const Center(
                  child: Text("No route to show yet."),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
