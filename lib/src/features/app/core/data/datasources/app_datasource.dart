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
  Future<Either<Failure, List<PlaceModel>>> searchGoogleNearby({
    String? placeName,
    String? type,
    required bool isAttraction,
    required LocationEntity locationEntity,
  });
  Future<Either<Failure, PlaceModel>> getGooglePlace(String placeId);
  Future<Either<Failure, List<PlaceModel>>> getPlaceListCache({
    required String key,
    String? placeName,
    LocationEntity? location,
  });
  Future<void> setFavouriteCache(
    String email,
    PlaceEntity placeEntity,
    bool isFavourite,
  );
  Future<Either<Failure, List<PlaceModel>>> getFavouriteListCache(String email);
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
    localDataSource.remove(LocalKey.attractionKey);

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

    if (!localDataSource.has(LocalKey.nearbyKey)) {
      await localDataSource.store(LocalKey.nearbyKey, jsonEncode([]));
    }

    if (!localDataSource.has(LocalKey.userKey)) {
      await localDataSource.store(LocalKey.userKey, jsonEncode([]));
    }

    final userModel = UserModel.fromJson(response.data);

    return Right(userModel);
  }

  @override
  Future<Either<Failure, List<PlaceModel>>> searchGoogleNearby({
    String? placeName,
    String? type,
    required bool isAttraction,
    required LocationEntity locationEntity,
  }) async {
    final apiEither = await apiDataSource.get(
      Uri.parse(
        '${ApiUrl.placeGoogleNearby}?latitude=${locationEntity.latitude}&longitude=${locationEntity.longitude}&type=$type',
      ),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    final response = apiEither.getOrElse(() => ResponseEntity.empty);

    if (!response.isSuccess) {
      return Left(SystemFailure(message: response.message));
    }

    if (isAttraction) {
      final places = await storeAttractionListCache(
        placeName!,
        (response.data['results'] as List).take(5).toList(),
      );

      return Right(places);
    }

    final placesModel = PlaceModel.fromList(
      (response.data['results'] as List).take(3).toList(),
    );

    return Right(placesModel);
  }

  @override
  Future<Either<Failure, PlaceModel>> getGooglePlace(String placeId) async {
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

    await addNearbyCache(response.data['result']);

    final placeModel = PlaceModel.fromJson(response.data['result']);

    return Right(placeModel);
  }

  @override
  Future<Either<Failure, List<PlaceModel>>> getPlaceListCache({
    required String key,
    String? placeName,
    LocationEntity? location,
  }) async {
    final cacheList = await getCacheList(key);

    if (key == LocalKey.attractionKey) {
      final placeIndex = cacheList.indexWhere(
        (element) => element['placeName'] == placeName,
      );

      if (placeIndex == -1) {
        return const Right([]);
      }

      final placeList = PlaceModel.fromList(cacheList[placeIndex]['places']);

      return Right(placeList);
    }

    final placeList = PlaceModel.fromList(cacheList);

    return Right(placeList);
  }

  Future<List<dynamic>> getCacheList(String localKey) async {
    if (!localDataSource.has(localKey)) {
      await localDataSource.store(localKey, jsonEncode([]));
    }

    final cacheData = await localDataSource.get(localKey);
    List<dynamic> cacheList = jsonDecode(cacheData);

    return cacheList;
  }

  @override
  Future<void> setFavouriteCache(
    String email,
    PlaceEntity placeEntity,
    bool isFavourite,
  ) async {
    final cacheList = await getCacheList(LocalKey.userKey);

    final emailIndex = cacheList.indexWhere(
      (element) => element['email'] == email,
    );

    if (isFavourite) {
      final jsonPlace = placeEntity.toJson();

      if (emailIndex != -1) {
        cacheList[emailIndex]['places'] = [
          ...cacheList[emailIndex]['places'],
          jsonPlace,
        ];
      } else {
        final jsonData = {
          "email": email,
          "places": [jsonPlace],
        };

        cacheList.add(jsonData);
      }
    }

    if (!isFavourite && emailIndex != -1) {
      final places = PlaceModel.fromList(cacheList[emailIndex]['places']);

      for (var data in places) {
        if (data.placeId == placeEntity.placeId) {
          final placeIndex = places.indexWhere(
            (element) => element.placeId == placeEntity.placeId,
          );

          places.removeAt(placeIndex);
          break;
        }
      }

      cacheList[emailIndex]['places'] = places;
    }

    await localDataSource.store(
      LocalKey.userKey,
      jsonEncode(cacheList),
    );
  }

  @override
  Future<Either<Failure, List<PlaceModel>>> getFavouriteListCache(
    String email,
  ) async {
    final cacheList = await getCacheList(LocalKey.userKey);

    for (var data in cacheList) {
      if (data['email'] == email) {
        final placeList = PlaceModel.fromList(data['places']);

        return Right(placeList);
      }
    }

    return const Right([]);
  }

  Future<List<PlaceModel>> storeAttractionListCache(
    String placeName,
    List<dynamic> dataList,
  ) async {
    List<dynamic> cacheList = await getCacheList(LocalKey.attractionKey);

    final placeIndex = cacheList.indexWhere(
      (element) => element['placeName'] == placeName,
    );

    if (placeIndex != -1) {
      cacheList[placeIndex]['places'] = [
        ...cacheList[placeIndex]['places'],
        ...dataList,
      ];
    } else {
      cacheList.add({"placeName": placeName, "places": dataList});
    }

    await localDataSource.store(
      LocalKey.attractionKey,
      jsonEncode(cacheList),
    );

    if (placeIndex == -1) {
      return [];
    }

    final placesModel = PlaceModel.fromList(cacheList[placeIndex]['places']);

    return placesModel;
  }

  Future<void> addNearbyCache(Map<String, dynamic> data) async {
    final cacheList = await getCacheList(LocalKey.nearbyKey);

    cacheList.add(data);

    await localDataSource.store(
      LocalKey.nearbyKey,
      jsonEncode(cacheList),
    );
  }
}
