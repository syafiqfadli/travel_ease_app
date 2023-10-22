import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:travel_ease_app/src/core/app/presentation/widgets/input_field.dart';
import 'package:travel_ease_app/src/core/utils/constants.dart';
import 'package:travel_ease_app/src/features/app/app_injector.dart';
import 'package:travel_ease_app/src/features/app/core/domain/entities/place/place_entity.dart';
import 'package:travel_ease_app/src/features/app/features/home/presentation/bloc/places_cubit.dart';
import 'package:travel_ease_app/src/features/app/features/home/presentation/bloc/select_place_cubit.dart';
import 'package:travel_ease_app/src/features/app/features/home/presentation/widgets/place_card.dart';
import 'package:travel_ease_app/src/features/app/features/home/presentation/widgets/place_details_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PlacesCubit placesCubit = appInjector<PlacesCubit>();
  final SelectPlaceCubit selectPlaceCubit = SelectPlaceCubit();
  final TextEditingController placeController = TextEditingController();

  final Completer<GoogleMapController> completerController =
      Completer<GoogleMapController>();

  static const CameraPosition _initPosition = CameraPosition(
    target: LatLng(2.1926, 102.2505),
    zoom: 14.45,
  );

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => placesCubit),
        BlocProvider(create: (context) => selectPlaceCubit),
      ],
      child: Stack(
        children: [
          GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: _initPosition,
            onMapCreated: (GoogleMapController controller) {
              completerController.complete(controller);
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
                  onChanged: (value) {
                    if (value == '') {
                      placesCubit.clearSearch();
                    }
                  },
                  onFieldSubmitted: (_) => _searchPlace(),
                ),
                const SizedBox(height: 5),
                BlocBuilder<PlacesCubit, PlacesState>(
                  builder: (context, state) {
                    if (state is PlacesLoaded) {
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

                    if (state is PlacesLoading) {
                      return Container(
                        height: 100,
                        width: width,
                        decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10)),
                          color: PrimaryColor.pureWhite,
                        ),
                        child: const Center(
                          child: CircularProgressIndicator(),
                        ),
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

    placesCubit.searchPlaces(query);
  }
}
