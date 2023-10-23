import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travel_ease_app/src/core/app/presentation/widgets/loading.dart';
import 'package:travel_ease_app/src/features/app/core/domain/entities/place/place_entity.dart';
import 'package:travel_ease_app/src/features/app/features/attraction/presentation/bloc/place_details_cubit.dart';
import 'package:travel_ease_app/src/features/app/features/attraction/presentation/widgets/has_details.dart';
import 'package:travel_ease_app/src/features/app/features/attraction/presentation/widgets/place_marker.dart';

class HasResult extends StatelessWidget {
  final List<PlaceEntity> places;

  const HasResult({super.key, required this.places});

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;

    String setLocation(int index) {
      if (index == 0) {
        return 'left';
      }

      if (index == 1) {
        return 'center';
      }

      if (index == 2) {
        return 'right';
      }

      return '';
    }

    return SingleChildScrollView(
      child: SizedBox(
        height: height * 0.8,
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 30, horizontal: 20),
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
                Image.asset('assets/images/map.jpg'),
                PlaceMarker(place: places[0], location: setLocation(0)),
                PlaceMarker(place: places[1], location: setLocation(1)),
                PlaceMarker(place: places[2], location: setLocation(2)),
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
