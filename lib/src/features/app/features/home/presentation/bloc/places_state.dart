part of 'places_cubit.dart';

sealed class PlacesState extends Equatable {
  const PlacesState();

  @override
  List<Object> get props => [];
}

final class PlacesInitial extends PlacesState {}

final class PlacesLoading extends PlacesState {}

final class PlacesLoaded extends PlacesState {
  final List<PlaceEntity> places;

  const PlacesLoaded({required this.places});

  @override
  List<Object> get props => [places];
}

final class PlacesError extends PlacesState {
  final String message;

  const PlacesError({required this.message});

  @override
  List<Object> get props => [message];
}
