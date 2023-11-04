import 'package:dartz/dartz.dart';
import 'package:travel_ease_app/src/core/errors/failures.dart';
import 'package:travel_ease_app/src/features/app/core/data/datasources/app_datasource.dart';
import 'package:travel_ease_app/src/features/app/core/domain/entities/place/direction_entity.dart';
import 'package:travel_ease_app/src/features/app/core/domain/entities/place/location_entity.dart';
import 'package:travel_ease_app/src/features/app/core/domain/entities/place/place_entity.dart';
import 'package:travel_ease_app/src/features/app/core/domain/entities/user_entity.dart';

abstract class AppRepo {
  Future<Either<Failure, UserEntity>> userInfo(String token);
  Future<Either<Failure, List<PlaceEntity>>> placeList();
  Future<Either<Failure, PlaceEntity>> getGooglePlaceDetails(String placeId);
  Future<Either<Failure, DirectionEntity>> getGoogleDirection(
    String origin,
    String destination,
  );
  Future<Either<Failure, List<PlaceEntity>>> getPlacesCache(String email);
  Future<Either<Failure, List<PlaceEntity>>> searchGoogleNearby({
    String? placeName,
    String? type,
    required bool isAttraction,
    required LocationEntity locationEntity,
  });
  Future<Either<Failure, List<PlaceEntity>>> getNearbyCache({
    required String key,
    String? placeName,
    LocationEntity? location,
  });
  Future<void> setPlacesCache(
    String email,
    PlaceEntity placeEntity,
  );
}

class AppRepoImpl implements AppRepo {
  final AppDataSource appDataSource;

  AppRepoImpl({required this.appDataSource});

  @override
  Future<Either<Failure, UserEntity>> userInfo(String token) async {
    final userEither = await appDataSource.userInfo(token);

    return userEither.fold(
      (failure) => Left(ServerFailure(message: failure.message)),
      (user) => Right(user),
    );
  }

  @override
  Future<Either<Failure, List<PlaceEntity>>> placeList() async {
    final placeEither = await appDataSource.placeList();

    return placeEither.fold(
      (failure) => Left(SystemFailure(message: failure.message)),
      (places) => Right(places),
    );
  }

  @override
  Future<Either<Failure, List<PlaceEntity>>> searchGoogleNearby({
    String? placeName,
    String? type,
    required bool isAttraction,
    required LocationEntity locationEntity,
  }) async {
    final placesEither = await appDataSource.searchGoogleNearby(
      placeName: placeName,
      type: type,
      isAttraction: isAttraction,
      locationEntity: locationEntity,
    );

    return placesEither.fold(
      (failure) => Left(SystemFailure(message: failure.message)),
      (places) => Right(places),
    );
  }

  @override
  Future<Either<Failure, PlaceEntity>> getGooglePlaceDetails(
    String placeId,
  ) async {
    final placeEither = await appDataSource.getGooglePlaceDetails(placeId);

    return placeEither.fold(
      (failure) => Left(SystemFailure(message: failure.message)),
      (place) => Right(place),
    );
  }

  @override
  Future<Either<Failure, DirectionEntity>> getGoogleDirection(
    String origin,
    String destination,
  ) async {
    final placeEither = await appDataSource.getGoogleDirection(
      origin,
      destination,
    );

    return placeEither.fold(
      (failure) => Left(SystemFailure(message: failure.message)),
      (direction) => Right(direction),
    );
  }

  @override
  Future<Either<Failure, List<PlaceEntity>>> getNearbyCache({
    required String key,
    String? placeName,
    LocationEntity? location,
  }) async {
    final placesEither = await appDataSource.getNearbyCache(
      key: key,
      placeName: placeName,
      location: location,
    );

    return placesEither.fold(
      (failure) => Left(SystemFailure(message: failure.message)),
      (places) => Right(places),
    );
  }

  @override
  Future<Either<Failure, List<PlaceEntity>>> getPlacesCache(
    String email,
  ) async {
    final placesEither = await appDataSource.getPlacesCache(email);

    return placesEither.fold(
      (failure) => Left(SystemFailure(message: failure.message)),
      (places) => Right(places),
    );
  }

  @override
  Future<void> setPlacesCache(String email, PlaceEntity placeEntity) async {
    await appDataSource.setPlacesCache(email, placeEntity);
  }
}
