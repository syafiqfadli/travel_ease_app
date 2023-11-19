part of 'attraction_details_cubit.dart';

sealed class AttractionDetailsState extends Equatable {
  const AttractionDetailsState();

  @override
  List<Object> get props => [];
}

final class AttractionDetailsInitial extends AttractionDetailsState {}

final class AttractionDetailsLoading extends AttractionDetailsState {}

final class AttractionDetailsLoaded extends AttractionDetailsState {
  final PlaceEntity place;

  const AttractionDetailsLoaded({required this.place});

  @override
  List<Object> get props => [place];
}
