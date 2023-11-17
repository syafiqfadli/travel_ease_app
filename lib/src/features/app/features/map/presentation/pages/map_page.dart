import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:travel_ease_app/src/core/app/presentation/widgets/input_field.dart';
import 'package:travel_ease_app/src/core/app/presentation/widgets/loading.dart';
import 'package:travel_ease_app/src/core/utils/constants.dart';
import 'package:travel_ease_app/src/features/app/app_injector.dart';
import 'package:travel_ease_app/src/features/app/core/domain/entities/place/place_entity.dart';
import 'package:travel_ease_app/src/features/app/features/map/presentation/bloc/marker_list_cubit.dart';
import 'package:travel_ease_app/src/features/app/features/map/presentation/bloc/place_list_cubit.dart';
import 'package:travel_ease_app/src/features/app/features/map/presentation/bloc/polyline_list_cubit.dart';
import 'package:travel_ease_app/src/features/app/features/map/presentation/bloc/search_places_cubit.dart';
import 'package:travel_ease_app/src/features/app/features/map/presentation/bloc/select_place_cubit.dart';
import 'package:travel_ease_app/src/features/app/features/map/presentation/widgets/map_widget.dart';
import 'package:travel_ease_app/src/features/app/features/map/presentation/widgets/place_card.dart';
import 'package:travel_ease_app/src/features/app/features/map/presentation/widgets/place_details_card.dart';

class MapPage extends StatefulWidget {
  final bool isRoute;
  final CameraPosition initPosition;

  const MapPage({
    super.key,
    this.isRoute = false,
    this.initPosition = const CameraPosition(
      target: LatLng(2.1926, 102.2505),
      zoom: 14.45,
    ),
  });

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final SearchPlacesCubit searchPlaceCubit = appInjector<SearchPlacesCubit>();
  final SelectPlaceCubit selectPlaceCubit = appInjector<SelectPlaceCubit>();
  final MarkerListCubit markerListCubit = appInjector<MarkerListCubit>();
  final PolylineListCubit polylineListCubit = appInjector<PolylineListCubit>();
  final PlaceListCubit placeListCubit = appInjector<PlaceListCubit>();

  final TextEditingController placeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    searchPlaceCubit.clearSearch();
    selectPlaceCubit.removePlace();
  }

  @override
  void dispose() {
    super.dispose();
    placeController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;

    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: searchPlaceCubit),
        BlocProvider.value(value: selectPlaceCubit),
        BlocProvider.value(value: markerListCubit),
        BlocProvider.value(value: polylineListCubit),
        BlocProvider.value(value: placeListCubit),
      ],
      child: Stack(
        children: [
          MapWidget(
            initPosition: widget.initPosition,
            isRoute: widget.isRoute,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: Column(
              children: [
                CustomInputField(
                  textController: placeController,
                  hint: "Search Place...",
                  suffixIcon: IconButton(
                    onPressed: _searchPlace,
                    icon: const Icon(Icons.search),
                  ),
                  hasBorder: true,
                  onFieldSubmitted: (_) => _searchPlace(),
                  onChanged: (value) {
                    if (value!.isEmpty) {
                      searchPlaceCubit.clearSearch();
                      selectPlaceCubit.removePlace();
                    }
                  },
                ),
                const SizedBox(height: 5),
                BlocBuilder<SearchPlacesCubit, SearchPlacesState>(
                  builder: (context, state) {
                    if (state is SearchPlacesLoaded) {
                      final places = state.places;

                      if (places.isEmpty) {
                        return Container(
                          height: 100,
                          width: width,
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(10),
                            ),
                            color: PrimaryColor.pureWhite,
                          ),
                          child: const Center(
                            child: Text("No place found."),
                          ),
                        );
                      }

                      return Container(
                        height: places.length > 3 ? 200 : null,
                        width: width,
                        padding: const EdgeInsets.symmetric(
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.all(
                            Radius.circular(10),
                          ),
                          color: PrimaryColor.pureWhite,
                        ),
                        child: ListView.builder(
                          physics: const BouncingScrollPhysics(
                            parent: AlwaysScrollableScrollPhysics(),
                          ),
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
                          borderRadius: const BorderRadius.all(
                            Radius.circular(10),
                          ),
                          color: PrimaryColor.pureWhite,
                        ),
                        child: const CustomLoading(),
                      );
                    }

                    if (state is SearchPlacesError) {
                      return Container(
                        height: 100,
                        width: width,
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.all(
                            Radius.circular(10),
                          ),
                          color: PrimaryColor.pureWhite,
                        ),
                        child: Center(
                          child: Text(state.message),
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
                          isRoute: widget.isRoute,
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
