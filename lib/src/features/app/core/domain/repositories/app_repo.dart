import 'package:dartz/dartz.dart';
import 'package:travel_ease_app/src/core/errors/failures.dart';
import 'package:travel_ease_app/src/features/app/core/data/datasources/app_datasource.dart';
import 'package:travel_ease_app/src/features/app/core/domain/entities/place/location_entity.dart';
import 'package:travel_ease_app/src/features/app/core/domain/entities/place/place_entity.dart';
import 'package:travel_ease_app/src/features/app/core/domain/entities/user_entity.dart';

abstract class AppRepo {
  Future<Either<Failure, UserEntity>> userInfo(String token);
  Future<Either<Failure, List<PlaceEntity>>> searchGoogleNearby({
    String? placeName,
    String? type,
    required bool isAttraction,
    required LocationEntity locationEntity,
  });
  Future<Either<Failure, PlaceEntity>> getGooglePlace(String placeId);
  Future<Either<Failure, List<PlaceEntity>>> getPlaceListCache({
    required String key,
    String? placeName,
    LocationEntity? location,
  });
  Future<void> setFavouriteCache(
    String email,
    PlaceEntity placeEntity,
    bool isFavourite,
  );
  Future<Either<Failure, List<PlaceEntity>>> getFavouriteListCache(
    String email,
  );
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
  Future<Either<Failure, PlaceEntity>> getGooglePlace(String placeId) async {
    final placeEither = await appDataSource.getGooglePlace(placeId);

    return placeEither.fold(
      (failure) => Left(SystemFailure(message: failure.message)),
      (place) => Right(place),
    );
  }

  @override
  Future<Either<Failure, List<PlaceEntity>>> getPlaceListCache({
    required String key,
    String? placeName,
    LocationEntity? location,
  }) async {
    final placesEither = await appDataSource.getPlaceListCache(
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
  Future<void> setFavouriteCache(
    String email,
    PlaceEntity placeEntity,
    bool isFavourite,
  ) async {
    await appDataSource.setFavouriteCache(
      email,
      placeEntity,
      isFavourite,
    );
  }

  @override
  Future<Either<Failure, List<PlaceEntity>>> getFavouriteListCache(
    String email,
  ) async {
    final placesEither = await appDataSource.getFavouriteListCache(email);

    return placesEither.fold(
      (failure) => Left(SystemFailure(message: failure.message)),
      (places) => Right(places),
    );
  }
}
