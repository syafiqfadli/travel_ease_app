import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:travel_ease_app/src/core/app/presentation/widgets/input_field.dart';
import 'package:travel_ease_app/src/core/app/presentation/widgets/loading.dart';
import 'package:travel_ease_app/src/core/utils/constants.dart';
import 'package:travel_ease_app/src/features/app/app_injector.dart';
import 'package:travel_ease_app/src/features/app/core/domain/entities/place/place_entity.dart';
import 'package:travel_ease_app/src/features/app/features/map/presentation/bloc/favourite_place_cubit.dart';
import 'package:travel_ease_app/src/features/app/features/map/presentation/bloc/marker_list_cubit.dart';
import 'package:travel_ease_app/src/features/app/features/map/presentation/bloc/polyline_list_cubit.dart';
import 'package:travel_ease_app/src/features/app/features/map/presentation/bloc/search_places_cubit.dart';
import 'package:travel_ease_app/src/features/app/features/map/presentation/bloc/select_place_cubit.dart';
import 'package:travel_ease_app/src/features/app/features/map/presentation/widgets/place_card.dart';
import 'package:travel_ease_app/src/features/app/features/map/presentation/widgets/place_details_card.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final SearchPlacesCubit searchPlaceCubit = appInjector<SearchPlacesCubit>();
  final SelectPlaceCubit selectPlaceCubit = SelectPlaceCubit();
  final FavouritePlaceCubit favouritePlaceCubit =
      appInjector<FavouritePlaceCubit>();
  final MarkerListCubit addMarkerCubit = appInjector<MarkerListCubit>();
  final PolylineListCubit addPolylineCubit = PolylineListCubit();
  final TextEditingController placeController = TextEditingController();

  final Completer<GoogleMapController> completerController =
      Completer<GoogleMapController>();

  static const CameraPosition _initPosition = CameraPosition(
    target: LatLng(2.1926, 102.2505),
    zoom: 14.45,
  );

  List<LatLng> routeCoords = [];

  @override
  void dispose() {
    super.dispose();
    searchPlaceCubit.clearSearch();
    selectPlaceCubit.removePlace();
    placeController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;

    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: searchPlaceCubit),
        BlocProvider.value(value: selectPlaceCubit),
        BlocProvider.value(value: addMarkerCubit),
        BlocProvider.value(value: addPolylineCubit),
        BlocProvider.value(value: favouritePlaceCubit),
      ],
      child: Stack(
        children: [
          BlocBuilder<MarkerListCubit, List<Marker>>(
            builder: (context, markers) {
              return BlocBuilder<PolylineListCubit, List<Polyline>>(
                builder: (context, polylines) {
                  return GoogleMap(
                    mapType: MapType.normal,
                    initialCameraPosition: _initPosition,
                    markers: Set.from(markers),
                    polylines: Set.from(polylines),
                    onMapCreated: (GoogleMapController controller) {
                      completerController.complete(controller);
                    },
                  );
                },
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: Column(
              children: [
                CustomInputField(
                  textController: placeController,
                  hint: "Search Place...",
                  suffixIcon: IconButton(
                    onPressed: () => _searchPlace(),
                    icon: const Icon(Icons.search),
                  ),
                  hasBorder: true,
                  onFieldSubmitted: (_) => _searchPlace(),
                ),
                const SizedBox(height: 5),
                BlocBuilder<SearchPlacesCubit, SearchPlacesState>(
                  builder: (context, state) {
                    if (state is SearchPlacesLoaded) {
                      final places = state.places;

                      if (places.isEmpty) {
                        return const SizedBox.shrink();
                      }

                      return Container(
                        height: places.length > 3 ? 200 : null,
                        width: width,
                        padding: const EdgeInsets.symmetric(
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10)),
                          color: PrimaryColor.pureWhite,
                        ),
                        child: ListView.builder(
                          shrinkWrap: places.length <= 3,
                          itemCount: places.length,
                          itemBuilder: (context, index) {
                            return PlaceCard(place: places[index]);
                          },
                        ),
                      );
                    }

                    if (state is SearchPlacesLoading) {
                      return Container(
                        height: 100,
                        width: width,
                        decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10)),
                          color: PrimaryColor.pureWhite,
                        ),
                        child: const CustomLoading(),
                      );
                    }

                    return const SizedBox.shrink();
                  },
                ),
              ],
            ),
          ),
          BlocBuilder<SelectPlaceCubit, PlaceEntity?>(
            builder: (context, state) {
              return Visibility(
                visible: state != null,
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: state == null
                      ? const SizedBox.shrink()
                      : PlaceDetailsCard(
                          place: state,
                          completerController: completerController,
                        ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  void _searchPlace() {
    final String query = placeController.text;

    searchPlaceCubit.searchPlaces(query);
  }
}
