part of 'nearby_places_cubit.dart';

sealed class NearbyPlacesState extends Equatable {
  const NearbyPlacesState();

  @override
  List<Object> get props => [];
}

final class NearbyPlacesInitial extends NearbyPlacesState {}

final class NearbyPlacesLoading extends NearbyPlacesState {
  final String status;

  const NearbyPlacesLoading({required this.status});

  @override
  List<Object> get props => [status];
}

final class NearbyPlacesLoaded extends NearbyPlacesState {
  final List<PlaceEntity> places;

  const NearbyPlacesLoaded({required this.places});

  @override
  List<Object> get props => [places];
}

final class NearbyPlacesError extends NearbyPlacesState {
  final String message;

  const NearbyPlacesError({required this.message});

  @override
  List<Object> get props => [message];
}
