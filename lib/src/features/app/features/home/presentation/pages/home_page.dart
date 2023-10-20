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

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;

    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: placesCubit),
        BlocProvider(create: (context) => selectPlaceCubit),
      ],
      child: GestureDetector(
        // onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Stack(
          children: [
            GoogleMap(
              mapType: MapType.normal,
              initialCameraPosition: _kGooglePlex,
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
                    suffixIcon: const Icon(Icons.search),
                    hasBorder: true,
                    onFieldSubmitted: (value) {
                      _searchPlace();
                    },
                  ),
                  const SizedBox(height: 5),
                  BlocBuilder<PlacesCubit, PlacesState>(
                    builder: (context, state) {
                      if (state is PlacesLoaded && placeController.text != '') {
                        final places = state.places;

                        return Container(
                          height: 200,
                          padding: const EdgeInsets.symmetric(
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10)),
                            color: PrimaryColor.pureWhite,
                          ),
                          width: width,
                          child: ListView.builder(
                            itemCount: places.length,
                            itemBuilder: (context, index) {
                              return PlaceCard(place: places[index]);
                            },
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
                  visible: state == null ? false : true,
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
      ),
    );
  }

  Future<void> _searchPlace() async {
    final String query = placeController.text;

    placesCubit.searchPlaces(query);
  }
}
