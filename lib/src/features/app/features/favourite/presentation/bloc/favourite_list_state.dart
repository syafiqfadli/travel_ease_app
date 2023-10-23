part of 'favourite_list_cubit.dart';

sealed class FavouriteListState extends Equatable {
  const FavouriteListState();

  @override
  List<Object> get props => [];
}

final class FavouriteInitial extends FavouriteListState {}

final class FavouriteLoading extends FavouriteListState {}

final class FavouriteLoaded extends FavouriteListState {
  final List<PlaceEntity> places;

  const FavouriteLoaded({required this.places});

  @override
  List<Object> get props => [places];
}

final class FavouriteError extends FavouriteListState {
  final String message;

  const FavouriteError({required this.message});

  @override
  List<Object> get props => [message];
}
