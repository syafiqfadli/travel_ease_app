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

  const CalculateRouteLoaded({required this.direction, required this.cost});

  @override
  List<Object> get props => [direction, cost];
}

final class CalculateRouteError extends CalculateRouteState {
  final String message;

  const CalculateRouteError({required this.message});

  @override
  List<Object> get props => [message];
}
