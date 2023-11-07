import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:travel_ease_app/src/features/app/core/domain/entities/place/direction_entity.dart';
import 'package:travel_ease_app/src/features/app/core/domain/entities/place/price_entity.dart';
import 'package:travel_ease_app/src/features/app/core/domain/repositories/app_repo.dart';
import 'package:travel_ease_app/src/features/app/features/map/presentation/bloc/show_route_cubit.dart';

part 'calculate_route_state.dart';

class CalculateRouteCubit extends Cubit<CalculateRouteState> {
  final AppRepo appRepo;
  final ShowRouteCubit showRouteCubit;

  CalculateRouteCubit({
    required this.appRepo,
    required this.showRouteCubit,
  }) : super(CalculateRouteInitial());

  void calculateRoute() async {
    List<DirectionEntity> directionList = [];
    DirectionEntity directionEntity = DirectionEntity.empty;
    Map<String, double> cost = {};

    emit(const CalculateRouteLoading(status: 'Getting places data...'));

    final routePlaces = showRouteCubit.state;

    emit(
      const CalculateRouteLoading(status: 'Calculating cost and duration...'),
    );

    // Calculate cost
    for (var element in routePlaces) {
      _calculateCost(cost, element.prices);
    }

    // Calculate direction
    for (var i = 0; i < routePlaces.length; i++) {
      if (i == routePlaces.length - 1) {
        break;
      }

      final directionEither = await appRepo.getGoogleDirection(
        routePlaces[i].placeName,
        routePlaces[i + 1].placeName,
      );

      final direction = directionEither.getOrElse(
        () => DirectionEntity.empty,
      );

      directionList.add(direction);
    }

    directionEntity = _calculateDirection(directionList);

    emit(CalculateRouteLoaded(direction: directionEntity, cost: cost));
  }

  void _calculateCost(Map<String, double> cost, List<PriceEntity> prices) {
    for (var element in prices) {
      final category = element.category;
      final price = element.price;

      if (cost.containsKey(category)) {
        cost[category] = (cost[category] ?? 0) + price;
      } else {
        cost[category] = price;
      }
    }
  }

  DirectionEntity _calculateDirection(List<DirectionEntity> directionList) {
    int duration = 0;
    int distance = 0;

    for (var element in directionList) {
      duration += element.duration;
      distance += element.distance;
    }

    return DirectionEntity(distance: distance, duration: duration);
  }

  void reset() {
    emit(CalculateRouteInitial());
  }
}
