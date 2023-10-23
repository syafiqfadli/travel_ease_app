import 'package:dartz/dartz.dart';
import 'package:travel_ease_app/src/core/errors/failures.dart';
import 'package:travel_ease_app/src/features/app/core/data/datasources/app_datasource.dart';
import 'package:travel_ease_app/src/features/app/core/domain/entities/place/location_entity.dart';
import 'package:travel_ease_app/src/features/app/core/domain/entities/place/place_entity.dart';
import 'package:travel_ease_app/src/features/app/core/domain/entities/user_entity.dart';

abstract class AppRepo {
  Future<Either<Failure, UserEntity>> userInfo(String token);
  Future<Either<Failure, List<PlaceEntity>>> searchPlaces(String query);
  Future<Either<Failure, List<PlaceEntity>>> searchNearby(
    LocationEntity locationEntity,
  );
  Future<Either<Failure, PlaceEntity>> placeDetails(String placeId);
  Future<Either<Failure, List<PlaceEntity>>> getPlacesFromStorage();
  Future<void> favouritePlace(PlaceEntity placeEntity, bool isFavourite);
  Future<Either<Failure, List<PlaceEntity>>> getFavouritePlace();
}

class AppRepoImpl implements AppRepo {
  final AppDataSource appDataSource;

  AppRepoImpl({required this.appDataSource});

  @override
  Future<Either<Failure, UserEntity>> userInfo(String token) async {
    final userEither = await appDataSource.userInfo(token);

    return userEither.fold(
      (failure) => Left(SystemFailure(message: failure.message)),
      (user) => Right(user),
    );
  }

  @override
  Future<Either<Failure, List<PlaceEntity>>> searchPlaces(String query) async {
    final placesEither = await appDataSource.searchPlaces(query);

    return placesEither.fold(
      (failure) => Left(SystemFailure(message: failure.message)),
      (places) => Right(places),
    );
  }

  @override
  Future<Either<Failure, List<PlaceEntity>>> searchNearby(
    LocationEntity locationEntity,
  ) async {
    final placesEither = await appDataSource.searchNearby(
      locationEntity,
    );

    return placesEither.fold(
      (failure) => Left(SystemFailure(message: failure.message)),
      (places) => Right(places),
    );
  }

  @override
  Future<Either<Failure, PlaceEntity>> placeDetails(String placeId) async {
    final placeEither = await appDataSource.placeDetails(placeId);

    return placeEither.fold(
      (failure) => Left(SystemFailure(message: failure.message)),
      (place) => Right(place),
    );
  }

  @override
  Future<Either<Failure, List<PlaceEntity>>> getPlacesFromStorage() async {
    final placesEither = await appDataSource.getPlacesFromStorage();

    return placesEither.fold(
      (failure) => Left(SystemFailure(message: failure.message)),
      (places) => Right(places),
    );
  }

  @override
  Future<void> favouritePlace(PlaceEntity placeEntity, bool isFavourite) async {
    await appDataSource.favouritePlace(placeEntity, isFavourite);
  }

  @override
  Future<Either<Failure, List<PlaceEntity>>> getFavouritePlace() async {
    final placesEither = await appDataSource.getFavouritePlace();

    return placesEither.fold(
      (failure) => Left(SystemFailure(message: failure.message)),
      (places) => Right(places),
    );
  }
}
