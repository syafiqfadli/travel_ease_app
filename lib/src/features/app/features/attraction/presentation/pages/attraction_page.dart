import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travel_ease_app/src/features/app/app_injector.dart';
import 'package:travel_ease_app/src/features/app/features/attraction/presentation/bloc/nearby_places_cubit.dart';
import 'package:travel_ease_app/src/features/app/features/attraction/presentation/bloc/place_details_cubit.dart';
import 'package:travel_ease_app/src/features/app/features/attraction/presentation/widgets/has_result.dart';
import 'package:travel_ease_app/src/features/app/features/attraction/presentation/widgets/loading_result.dart';

class AttractionPage extends StatefulWidget {
  const AttractionPage({super.key});

  @override
  State<AttractionPage> createState() => _AttractionPageState();
}

class _AttractionPageState extends State<AttractionPage> {
  final NearbyPlacesCubit nearbyPlacesCubit = appInjector<NearbyPlacesCubit>();
  final PlaceDetailsCubit placeDetailsCubit = appInjector<PlaceDetailsCubit>();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: nearbyPlacesCubit),
        BlocProvider.value(value: placeDetailsCubit),
      ],
      child: Scaffold(body: BlocBuilder<NearbyPlacesCubit, NearbyPlacesState>(
        builder: (context, state) {
          if (state is NearbyPlacesLoading) {
            return LoadingResult(status: state.status);
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
            child: ElevatedButton(
              onPressed: () => _findNearby(),
              child: const Text("Find Nearby Place"),
            ),
          );
        },
      )),
    );
  }

  void _findNearby() {
    nearbyPlacesCubit.searchPlaces();
  }
}
