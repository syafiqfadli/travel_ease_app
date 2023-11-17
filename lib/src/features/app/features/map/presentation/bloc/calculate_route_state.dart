part of 'calculate_route_cubit.dart';

sealed class CalculateRouteState extends Equatable {
  const CalculateRouteState();

  @override
  List<Object> get props => [];
}

final class CalculateRouteInitial extends CalculateRouteState {}

final class CalculateRouteLoading extends CalculateRouteState {
  final String status;

  const CalculateRouteLoading({required this.status});

  @override
  List<Object> get props => [status];
}

final class CalculateRouteLoaded extends CalculateRouteState {
  final DirectionEntity direction;
  final Map<String, double> cost;
  final LocationEntity initPosition;
  final List<PlaceEntity> places;

  const CalculateRouteLoaded({
    required this.direction,
    required this.cost,
    required this.initPosition,
    required this.places,
  });

  @override
  List<Object> get props => [
        direction,
        cost,
        initPosition,
        places,
      ];
}

final class CalculateRouteError extends CalculateRouteState {
  final String message;

  const CalculateRouteError({required this.message});

  @override
  List<Object> get props => [message];
}
