part of 'attraction_cubit.dart';

sealed class AttractionState extends Equatable {
  const AttractionState();

  @override
  List<Object> get props => [];
}

final class AttractionInitial extends AttractionState {}

final class AttractionLoading extends AttractionState {
  final String message;

  const AttractionLoading({required this.message});

  @override
  List<Object> get props => [message];
}

final class AttractionLoaded extends AttractionState {
  final List<PlaceEntity> places;

  const AttractionLoaded({required this.places});

  @override
  List<Object> get props => [places];
}

final class AttractionError extends AttractionState {
  final String message;

  const AttractionError({required this.message});

  @override
  List<Object> get props => [message];
}
