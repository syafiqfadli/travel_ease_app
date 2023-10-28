import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travel_ease_app/src/core/utils/constants.dart';
import 'package:travel_ease_app/src/features/app/app_injector.dart';
import 'package:travel_ease_app/src/features/app/features/near_me/presentation/bloc/nearby_places_cubit.dart';
import 'package:travel_ease_app/src/features/app/features/near_me/presentation/bloc/place_details_cubit.dart';
import 'package:travel_ease_app/src/features/app/features/near_me/presentation/widgets/has_result.dart';
import 'package:travel_ease_app/src/features/app/core/presentation/widgets/loading_status.dart';

class NearMePage extends StatefulWidget {
  const NearMePage({super.key});

  @override
  State<NearMePage> createState() => _NearMePageState();
}

class _NearMePageState extends State<NearMePage> {
  final NearbyPlacesCubit nearbyPlacesCubit = appInjector<NearbyPlacesCubit>();
  final PlaceDetailsCubit placeDetailsCubit = appInjector<PlaceDetailsCubit>();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: nearbyPlacesCubit),
        BlocProvider.value(value: placeDetailsCubit),
      ],
      child: Scaffold(
        body: BlocBuilder<NearbyPlacesCubit, NearbyPlacesState>(
          builder: (context, state) {
            if (state is NearbyPlacesLoading) {
              return LoadingStatus(status: state.status);
            }

            if (state is NearbyPlacesError) {
              return Center(
                child: Text(state.message),
              );
            }

            if (state is NearbyPlacesLoaded) {
              final places = state.places;

              return HasResult(places: places);
            }

            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.public, size: 80),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _findNearby,
                      style: ElevatedButton.styleFrom(
                        fixedSize: const Size(200, 50),
                        backgroundColor: PrimaryColor.navyBlack,
                      ),
                      child: const Text(
                        "Find Nearby Place",
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _findNearby() {
    nearbyPlacesCubit.searchPlaces();
  }
}
