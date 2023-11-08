import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travel_ease_app/src/core/app/presentation/widgets/loading.dart';
import 'package:travel_ease_app/src/features/app/core/domain/entities/place/place_entity.dart';
import 'package:travel_ease_app/src/features/app/features/near_me/presentation/bloc/nearby_places_cubit.dart';
import 'package:travel_ease_app/src/features/app/features/near_me/presentation/bloc/place_details_cubit.dart';
import 'package:travel_ease_app/src/features/app/features/near_me/presentation/widgets/has_details.dart';
import 'package:travel_ease_app/src/features/app/features/near_me/presentation/widgets/place_marker_list.dart';

class HasResult extends StatelessWidget {
  final List<PlaceEntity> places;

  const HasResult({super.key, required this.places});

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    return SingleChildScrollView(
      child: SizedBox(
        height: height - kToolbarHeight - kBottomNavigationBarHeight,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            IconButton(
              onPressed: () {
                context.read<NearbyPlacesCubit>().searchPlaces();
                context.read<PlaceDetailsCubit>().reset();
              },
              icon: const Icon(
                Icons.restart_alt_rounded,
                size: 30,
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(
                bottom: 30,
                left: 20,
                right: 20,
              ),
              child: Column(
                children: [
                  Text(
                    'Results',
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Check out the places in your area. Click below to view business hours.',
                    style: TextStyle(fontSize: 20),
                    textAlign: TextAlign.center,
                  )
                ],
              ),
            ),
            Stack(
              children: [
                SizedBox(
                  height: 300,
                  width: width,
                  child: Image.asset(
                    'assets/images/map.jpg',
                    fit: BoxFit.fill,
                  ),
                ),
                PlaceMarkerList(places: places),
              ],
            ),
            Expanded(
              child: BlocBuilder<PlaceDetailsCubit, PlaceDetailsState>(
                builder: (context, state) {
                  if (state is PlaceDetailsLoading) {
                    return const CustomLoading();
                  }

                  if (state is PlaceDetailsLoaded) {
                    final place = state.place;

                    return HasDetails(place: place);
                  }

                  return const Center(
                    child: Text('Please select place to view details.'),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
