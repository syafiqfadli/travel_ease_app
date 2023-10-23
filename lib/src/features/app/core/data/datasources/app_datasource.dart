import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:travel_ease_app/src/core/app/data/datasources/api_datasource.dart';
import 'package:travel_ease_app/src/core/app/data/datasources/local_datasource.dart';
import 'package:travel_ease_app/src/core/app/domain/entities/response_entity.dart';
import 'package:travel_ease_app/src/core/errors/failures.dart';
import 'package:travel_ease_app/src/core/utils/constants.dart';
import 'package:travel_ease_app/src/features/app/core/data/models/place/place_model.dart';
import 'package:travel_ease_app/src/features/app/core/data/models/user_model.dart';
import 'package:travel_ease_app/src/features/app/core/domain/entities/place/location_entity.dart';
import 'package:travel_ease_app/src/features/app/core/domain/entities/place/place_entity.dart';
import 'package:travel_ease_app/src/features/auth/core/data/datasources/auth_datasource.dart';

abstract class AppDataSource {
  Future<Either<Failure, UserModel>> userInfo(String token);
  Future<Either<Failure, List<PlaceModel>>> searchPlaces(String query);
  Future<Either<Failure, List<PlaceModel>>> searchNearby(
    LocationEntity locationEntity,
  );
  Future<Either<Failure, PlaceModel>> placeDetails(String placeId);
  Future<Either<Failure, List<PlaceModel>>> getPlacesFromStorage();
  Future<void> favouritePlace(PlaceEntity placeEntity, bool isFavourite);
  Future<Either<Failure, List<PlaceModel>>> getFavouritePlace();
}

class AppDataSourceImpl implements AppDataSource {
  final ApiDataSource apiDataSource;
  final LocalDataSource localDataSource;
  final AuthDataSource authDataSource;

  AppDataSourceImpl({
    required this.apiDataSource,
    required this.localDataSource,
    required this.authDataSource,
  });

  @override
  Future<Either<Failure, UserModel>> userInfo(String token) async {
    final apiEither = await apiDataSource.get(
      Uri.parse(ApiUrl.userInfo),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    final response = apiEither.getOrElse(() => ResponseEntity.empty);

    if (!response.isSuccess) {
      authDataSource.logout();

      return Left(SystemFailure(message: response.message));
    }

    if (!localDataSource.has(LocalKey.placeDetailsListKey) &&
        !localDataSource.has(LocalKey.favPlace)) {
      await localDataSource.store(LocalKey.placeDetailsListKey, jsonEncode([]));
      await localDataSource.store(LocalKey.favPlace, jsonEncode([]));
    }

    final userModel = UserModel.fromJson(response.data);

    return Right(userModel);
  }

  @override
  Future<Either<Failure, List<PlaceModel>>> searchPlaces(String query) async {
    final apiEither = await apiDataSource.get(
      Uri.parse('${ApiUrl.placeGoogleText}?query=$query'),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    final response = apiEither.getOrElse(() => ResponseEntity.empty);

    if (!response.isSuccess) {
      return Left(SystemFailure(message: response.message));
    }

    final placesModel = PlaceModel.fromList(response.data['results']);

    return Right(placesModel);
  }

  @override
  Future<Either<Failure, List<PlaceModel>>> searchNearby(
    LocationEntity locationEntity,
  ) async {
    final apiEither = await apiDataSource.get(
      Uri.parse(
          '${ApiUrl.placeGoogleNearby}?latitude=${locationEntity.latitude}&longitude=${locationEntity.longitude}'),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    final response = apiEither.getOrElse(() => ResponseEntity.empty);

    if (!response.isSuccess) {
      return Left(SystemFailure(message: response.message));
    }

    final placesModel = PlaceModel.fromList(response.data['results']);

    final filteredList = placesModel.take(3).toList();

    return Right(filteredList);
  }

  @override
  Future<Either<Failure, PlaceModel>> placeDetails(String placeId) async {
    final apiEither = await apiDataSource.get(
      Uri.parse('${ApiUrl.placeGoogleDetails}?placeId=$placeId'),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    final response = apiEither.getOrElse(() => ResponseEntity.empty);

    if (!response.isSuccess) {
      return Left(SystemFailure(message: response.message));
    }

    await addPlaceToStorage(response.data['result']);

    final placeModel = PlaceModel.fromJson(response.data['result']);

    return Right(placeModel);
  }

  @override
  Future<Either<Failure, List<PlaceModel>>> getPlacesFromStorage() async {
    if (!localDataSource.has(LocalKey.placeDetailsListKey)) {
      return const Left(ServerFailure(message: "No list"));
    }

    final cacheList = await localDataSource.get(LocalKey.placeDetailsListKey);
    List<dynamic> cacheJson = jsonDecode(cacheList);

    final placeList = PlaceModel.fromList(cacheJson);

    return Right(placeList);
  }

  @override
  Future<void> favouritePlace(PlaceEntity placeEntity, bool isFavourite) async {
    final cacheList = await getCacheList(LocalKey.favPlace);

    if (isFavourite) {
      final jsonPlace = placeEntity.toJson();

      cacheList.add(jsonPlace);

      return await localDataSource.store(
        LocalKey.favPlace,
        jsonEncode(cacheList),
      );
    }

    final places = PlaceModel.fromList(cacheList);

    for (var data in places) {
      if (data.placeId == placeEntity.placeId) {
        final placeIndex = places.indexWhere(
          (element) => element.placeId == placeEntity.placeId,
        );

        places.removeAt(placeIndex);

        return await localDataSource.store(
          LocalKey.favPlace,
          jsonEncode(places),
        );
      }
    }
  }

  @override
  Future<Either<Failure, List<PlaceModel>>> getFavouritePlace() async {
    try {
      if (!localDataSource.has(LocalKey.favPlace)) {
        return const Left(ServerFailure(message: "No list"));
      }

      final cacheList = await getCacheList(LocalKey.favPlace);

      final placeList = PlaceModel.fromList(cacheList);

      return Right(placeList);
    } catch (error) {
      return Left(ServerFailure(message: error.toString()));
    }
  }

  Future<void> addPlaceToStorage(Map<String, dynamic> data) async {
    final cacheList = await getCacheList(LocalKey.placeDetailsListKey);

    cacheList.add(data);

    await localDataSource.store(
      LocalKey.placeDetailsListKey,
      jsonEncode(cacheList),
    );
  }

  Future<List<dynamic>> getCacheList(String localKey) async {
    final cacheList = await localDataSource.get(localKey);
    List<dynamic> cacheJson = jsonDecode(cacheList);

    return cacheJson;
  }
}
