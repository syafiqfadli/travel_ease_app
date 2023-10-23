import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travel_ease_app/src/features/app/app_injector.dart';
import 'package:travel_ease_app/src/features/app/features/favourite/presentation/bloc/favourite_list_cubit.dart';

class FavouritePage extends StatefulWidget {
  const FavouritePage({super.key});

  @override
  State<FavouritePage> createState() => _FavouritePageState();
}

class _FavouritePageState extends State<FavouritePage> {
  final FavouriteListCubit favouriteListCubit =
      appInjector<FavouriteListCubit>();

  @override
  void initState() {
    super.initState();
    favouriteListCubit.getFavouritePlaces();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: favouriteListCubit,
      child: BlocBuilder<FavouriteListCubit, FavouriteListState>(
        builder: (context, state) {
          if (state is FavouriteLoaded) {
            final places = state.places;

            return ListView.builder(
              itemCount: places.length,
              itemBuilder: (context, index) {
                return Text(places[index].placeName);
              },
            );
          }

          return Container();
        },
      ),
    );
  }
}
