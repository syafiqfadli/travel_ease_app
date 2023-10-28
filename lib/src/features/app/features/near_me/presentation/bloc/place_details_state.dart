part of 'place_details_cubit.dart';

sealed class PlaceDetailsState extends Equatable {
  const PlaceDetailsState();

  @override
  List<Object> get props => [];
}

final class PlaceDetailsInitial extends PlaceDetailsState {}

final class PlaceDetailsLoading extends PlaceDetailsState {}

final class PlaceDetailsLoaded extends PlaceDetailsState {
  final PlaceEntity place;

  const PlaceDetailsLoaded({required this.place});

  @override
  List<Object> get props => [place];
}

final class PlaceDetailsError extends PlaceDetailsState {
  final String message;

  const PlaceDetailsError({required this.message});

  @override
  List<Object> get props => [message];
}
