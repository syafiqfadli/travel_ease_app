import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travel_ease_app/src/core/utils/constants.dart';
import 'package:travel_ease_app/src/core/utils/services.dart';
import 'package:travel_ease_app/src/features/app/app_injector.dart';
import 'package:travel_ease_app/src/features/app/core/domain/entities/place/direction_entity.dart';
import 'package:travel_ease_app/src/features/app/core/presentation/widgets/loading_status.dart';
import 'package:travel_ease_app/src/features/app/features/map/presentation/bloc/calculate_route_cubit.dart';
import 'package:travel_ease_app/src/features/app/features/map/presentation/bloc/place_prices_cubit.dart';
import 'package:travel_ease_app/src/features/app/features/map/presentation/bloc/show_route_cubit.dart';
import 'package:travel_ease_app/src/features/app/features/map/presentation/widgets/calculate_result_card.dart';

class CalculatePage extends StatefulWidget {
  const CalculatePage({super.key});

  @override
  State<CalculatePage> createState() => _CalculatePageState();
}

class _CalculatePageState extends State<CalculatePage> {
  final CalculateRouteCubit calculateRouteCubit =
      appInjector<CalculateRouteCubit>();
  final ShowRouteCubit showRouteCubit = appInjector<ShowRouteCubit>();
  final PlacePricesCubit placePricesCubit = appInjector<PlacePricesCubit>();

  @override
  void initState() {
    super.initState();
    calculateRouteCubit.calculateRoute();
  }

  @override
  void dispose() {
    super.dispose();
    calculateRouteCubit.reset();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: calculateRouteCubit),
        BlocProvider.value(value: showRouteCubit),
        BlocProvider.value(value: placePricesCubit),
      ],
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: PrimaryColor.navyBlack,
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.arrow_back_ios),
          ),
          title: const Text('CALCULATE ROUTES'),
          centerTitle: true,
        ),
        body: BlocBuilder<CalculateRouteCubit, CalculateRouteState>(
          builder: (context, state) {
            if (state is CalculateRouteLoading) {
              return LoadingStatus(status: state.status);
            }

            if (state is CalculateRouteLoaded) {
              final Map<String, double> cost = state.cost;
              final DirectionEntity direction = state.direction;
              final int destination = showRouteCubit.state.length;

              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Total destinations: ',
                          ),
                          Text(
                            destination.toString(),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 20),
                          ElevatedButton(
                            onPressed: _showPlannedDestinations,
                            style: ElevatedButton.styleFrom(
                              elevation: 0,
                              fixedSize: const Size(100, 20),
                              foregroundColor: PrimaryColor.navyBlack,
                              backgroundColor: PrimaryColor.backgroundGrey,
                              side: BorderSide(color: PrimaryColor.navyBlack),
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [Text("View"), Icon(Icons.pageview)],
                            ),
                          )
                        ],
                      ),
                      CalculateResultCard(
                        mode: 'car',
                        cost: cost,
                        direction: direction,
                      ),
                      CalculateResultCard(
                        mode: 'motor',
                        cost: cost,
                        direction: direction,
                      ),
                      CalculateResultCard(
                        mode: 'walk',
                        cost: cost,
                      ),
                    ],
                  ),
                ),
              );
            }

            return Container();
          },
        ),
      ),
    );
  }

  void _showPlannedDestinations() {
    DialogService.showPlacesPrice(
      context: context,
      places: placePricesCubit.state,
    );
  }
}
