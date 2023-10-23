part of 'search_places_cubit.dart';

sealed class SearchPlacesState extends Equatable {
  const SearchPlacesState();

  @override
  List<Object> get props => [];
}

final class SearchPlacesInitial extends SearchPlacesState {}

final class SearchPlacesLoading extends SearchPlacesState {}

final class SearchPlacesLoaded extends SearchPlacesState {
  final List<PlaceEntity> places;

  const SearchPlacesLoaded({required this.places});

  @override
  List<Object> get props => [places];
}

final class SearchPlacesError extends SearchPlacesState {
  final String message;

  const SearchPlacesError({required this.message});

  @override
  List<Object> get props => [message];
}
