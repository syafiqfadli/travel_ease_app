import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:travel_ease_app/src/core/app/presentation/widgets/column_builder.dart';
import 'package:travel_ease_app/src/core/utils/constants.dart';
import 'package:travel_ease_app/src/core/utils/helpers.dart';
import 'package:travel_ease_app/src/core/utils/services.dart';
import 'package:travel_ease_app/src/features/app/app_injector.dart';
import 'package:travel_ease_app/src/features/app/core/presentation/bloc/set_page_cubit.dart';
import 'package:travel_ease_app/src/features/app/core/presentation/pages/app_page.dart';
import 'package:travel_ease_app/src/features/app/core/presentation/widgets/loading_status.dart';
import 'package:travel_ease_app/src/features/app/features/map/presentation/bloc/calculate_route_cubit.dart';
import 'package:travel_ease_app/src/features/app/features/map/presentation/bloc/marker_list_cubit.dart';
import 'package:travel_ease_app/src/features/app/features/map/presentation/bloc/open_map_cubit.dart';
import 'package:travel_ease_app/src/features/app/features/map/presentation/bloc/place_list_cubit.dart';
import 'package:travel_ease_app/src/features/app/features/map/presentation/bloc/polyline_list_cubit.dart';
import 'package:travel_ease_app/src/features/app/features/map/presentation/bloc/search_places_cubit.dart';
import 'package:travel_ease_app/src/features/app/features/map/presentation/bloc/select_place_cubit.dart';
import 'package:travel_ease_app/src/features/app/features/map/presentation/pages/add_route_page.dart';
import 'package:travel_ease_app/src/features/app/features/map/presentation/widgets/map_widget.dart';
import 'package:travel_ease_app/src/features/app/features/map/presentation/widgets/route_result_card.dart';

class RoutePage extends StatefulWidget {
  const RoutePage({super.key});

  @override
  State<RoutePage> createState() => _RoutePageState();
}

class _RoutePageState extends State<RoutePage> {
  final SetPageCubit setPageCubit = appInjector<SetPageCubit>();
  final CalculateRouteCubit calculateRouteCubit =
      appInjector<CalculateRouteCubit>();
  final MarkerListCubit markerListCubit = appInjector<MarkerListCubit>();
  final PolylineListCubit polylineListCubit = appInjector<PolylineListCubit>();
  final SearchPlacesCubit searchPlacesCubit = appInjector<SearchPlacesCubit>();
  final SelectPlaceCubit selectPlaceCubit = appInjector<SelectPlaceCubit>();
  final PlaceListCubit placeListCubit = appInjector<PlaceListCubit>();
  final OpenMapCubit openMapCubit = OpenMapCubit();

  @override
  void initState() {
    super.initState();
    calculateRouteCubit.calculateRoute();
    markerListCubit.getMarkerList();
  }

  @override
  void dispose() {
    super.dispose();
    placeListCubit.clearList();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: setPageCubit),
        BlocProvider.value(value: calculateRouteCubit),
        BlocProvider.value(value: markerListCubit),
        BlocProvider.value(value: polylineListCubit),
        BlocProvider.value(value: searchPlacesCubit),
        BlocProvider.value(value: openMapCubit),
      ],
      child: WillPopScope(
        onWillPop: () {
          _navigateToMapPage();
          return Future.value(true);
        },
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Routes'),
            backgroundColor: PrimaryColor.navyBlack,
            leading: IconButton(
              onPressed: _navigateToMapPage,
              icon: const Icon(Icons.arrow_back_ios),
            ),
            actions: [
              BlocBuilder<CalculateRouteCubit, CalculateRouteState>(
                builder: (context, state) {
                  if (state is CalculateRouteLoaded) {
                    return state.places.length <= 3
                        ? IconButton(
                            onPressed: () async {
                              final bool result = await Navigator.of(context)
                                  .push(MaterialPageRoute(
                                builder: (context) => const AddRoutePage(),
                              ));

                              if (result) {
                                calculateRouteCubit.calculateRoute();
                              }
                            },
                            icon: const Icon(Icons.add),
                          )
                        : const SizedBox.shrink();
                  }

                  return const SizedBox.shrink();
                },
              ),
            ],
          ),
          body: BlocBuilder<CalculateRouteCubit, CalculateRouteState>(
            builder: (context, state) {
              if (state is CalculateRouteLoaded) {
                final initPosition = CameraPosition(
                  target: LatLng(
                    state.initPosition.latitude,
                    state.initPosition.longitude,
                  ),
                  zoom: 12,
                );

                return SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(
                        height: height * 0.35,
                        child: Stack(
                          children: [
                            MapWidget(
                              initPosition: initPosition,
                              isRoute: true,
                            ),
                            Container(
                              height: 50,
                              width: width,
                              decoration: BoxDecoration(
                                color: PrimaryColor.pureGrey,
                              ),
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                  ),
                                  child: AutoSizeText(
                                    StringHelper.setPlaceDirection(
                                      state.places,
                                    ),
                                    textAlign: TextAlign.center,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: PrimaryColor.pureWhite,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              top: 50,
                              right: 10,
                              child: ElevatedButton(
                                onPressed: _showMaps,
                                style: ElevatedButton.styleFrom(
                                  fixedSize: const Size(100, 20),
                                  backgroundColor: PrimaryColor.navyBlack,
                                ),
                                child: const Text('Open Map'),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: height * 0.5,
                        child: Column(
                          children: [
                            RouteResultCard(
                              mode: 'car',
                              cost: state.cost,
                              direction: state.direction,
                            ),
                            RouteResultCard(
                              mode: 'motor',
                              cost: state.cost,
                              direction: state.direction,
                            ),
                            RouteResultCard(
                              mode: 'walk',
                              cost: state.cost,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }

              if (state is CalculateRouteLoading) {
                return LoadingStatus(status: state.status);
              }

              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }

  void _navigateToMapPage() {
    setPageCubit.setPage(2);
    Navigator.of(context).pushReplacement(MaterialPageRoute(
      builder: (context) => const AppPage(),
    ));
  }

  void _showMaps() async {
    await openMapCubit.showAvailableMaps();

    if (!mounted) return;

    final mapList = openMapCubit.state;
    final place = placeListCubit.state[0];

    DialogService.showMaps(
      context: context,
      child: mapList.isEmpty
          ? const Center(
              child: Text(
                'No any map appilcation installed. Please install map application.',
              ),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 30,
                    horizontal: 15,
                  ),
                  child: Text(
                    'Available Maps:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                ColumnBuilder(
                  itemCount: mapList.length,
                  itemBuilder: (context, index) {
                    final map = mapList[index];

                    return ListTile(
                      leading: SvgPicture.asset(
                        map.icon,
                        height: 30,
                        width: 30,
                      ),
                      title: Text(map.mapName),
                      onTap: () {
                        openMapCubit.openMap(place, index);
                      },
                    );
                  },
                ),
              ],
            ),
    );
  }
}
