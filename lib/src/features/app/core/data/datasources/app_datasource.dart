import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:travel_ease_app/src/core/app/data/datasources/api_datasource.dart';
import 'package:travel_ease_app/src/core/app/data/datasources/local_datasource.dart';
import 'package:travel_ease_app/src/core/errors/failures.dart';
import 'package:travel_ease_app/src/core/utils/constants.dart';
import 'package:travel_ease_app/src/features/app/core/data/models/place/direction_model.dart';
import 'package:travel_ease_app/src/features/app/core/data/models/place/place_model.dart';
import 'package:travel_ease_app/src/features/app/core/data/models/user_model.dart';
import 'package:travel_ease_app/src/features/app/core/domain/entities/place/location_entity.dart';
import 'package:travel_ease_app/src/features/app/core/domain/entities/place/place_entity.dart';

abstract class AppDataSource {
  Future<Either<Failure, UserModel>> userInfo(String token);
  Future<Either<Failure, List<PlaceModel>>> placeList();
  Future<Either<Failure, PlaceModel>> getGooglePlaceDetails(String placeId);
  Future<Either<Failure, DirectionModel>> getGoogleDirection(
    String origin,
    String destination,
  );
  Future<Either<Failure, List<PlaceModel>>> getPlacesCache(String email);
  Future<Either<Failure, List<PlaceModel>>> searchGoogleNearby({
    String? placeName,
    String? type,
    required bool isAttraction,
    required LocationEntity locationEntity,
  });
  Future<Either<Failure, List<PlaceModel>>> getNearbyCache({
    required String key,
    String? placeName,
    LocationEntity? location,
  });
  Future<void> setPlacesCache(
    String email,
    PlaceEntity placeEntity,
  );
}

class AppDataSourceImpl implements AppDataSource {
  final ApiDataSource apiDataSource;
  final LocalDataSource localDataSource;

  AppDataSourceImpl({
    required this.apiDataSource,
    required this.localDataSource,
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

    return apiEither.fold(
      (failure) {
        return Left(SystemFailure(message: failure.message));
      },
      (response) {
        if (!response.isSuccess) {
          return Left(SystemFailure(message: response.message));
        }

        final userModel = UserModel.fromJson(response.data);

        return Right(userModel);
      },
    );
  }

  @override
  Future<Either<Failure, List<PlaceModel>>> placeList() async {
    final apiEither = await apiDataSource.get(
      Uri.parse(ApiUrl.placeList),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    return apiEither.fold(
      (failure) {
        return Left(SystemFailure(message: failure.message));
      },
      (response) {
        if (!response.isSuccess) {
          return Left(SystemFailure(message: response.message));
        }

        final placesModel = PlaceModel.fromList(response.data);

        return Right(placesModel);
      },
    );
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

    return apiEither.fold(
      (failure) {
        return Left(SystemFailure(message: failure.message));
      },
      (response) async {
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
      },
    );
  }

  @override
  Future<Either<Failure, PlaceModel>> getGooglePlaceDetails(
    String placeId,
  ) async {
    final apiEither = await apiDataSource.get(
      Uri.parse('${ApiUrl.placeGoogleDetails}?placeId=$placeId'),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    return apiEither.fold(
      (failure) {
        return Left(SystemFailure(message: failure.message));
      },
      (response) async {
        if (!response.isSuccess) {
          return Left(SystemFailure(message: response.message));
        }

        await addNearbyCache(response.data['result']);

        final placeModel = PlaceModel.fromJson(response.data['result']);

        return Right(placeModel);
      },
    );
  }

  @override
  Future<Either<Failure, DirectionModel>> getGoogleDirection(
    String origin,
    String destination,
  ) async {
    final apiEither = await apiDataSource.get(
      Uri.parse(
          '${ApiUrl.placeGoogleDirection}?origin=$origin&destination=$destination'),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    return apiEither.fold(
      (failure) {
        return Left(SystemFailure(message: failure.message));
      },
      (response) async {
        if (!response.isSuccess) {
          return Left(SystemFailure(message: response.message));
        }

        final directionModel = DirectionModel.fromJson(response.data);

        return Right(directionModel);
      },
    );
  }

  @override
  Future<Either<Failure, List<PlaceModel>>> getNearbyCache({
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

  @override
  Future<Either<Failure, List<PlaceModel>>> getPlacesCache(String email) async {
    final cacheList = await getCacheList(LocalKey.placesKey);

    for (var data in cacheList) {
      if (data['email'] == email) {
        final placeList = PlaceModel.fromList(data['places']);

        return Right(placeList);
      }
    }

    return const Right([]);
  }

  @override
  Future<void> setPlacesCache(String email, PlaceEntity placeEntity) async {
    final cacheList = await getCacheList(LocalKey.placesKey);
    final jsonPlace = placeEntity.toJson();

    final emailIndex = cacheList.indexWhere(
      (element) => element['email'] == email,
    );

    if (emailIndex != -1) {
      final places = cacheList[emailIndex]['places'] as List;

      for (var data in places) {
        if (data['placeId'] == placeEntity.placeId) {
          places.remove(data);
          break;
        }
      }

      places.add(jsonPlace);
    } else {
      final jsonData = {
        "email": email,
        "places": [jsonPlace],
      };

      cacheList.add(jsonData);
    }

    await localDataSource.store(
      LocalKey.placesKey,
      jsonEncode(cacheList),
    );
  }

  Future<List<dynamic>> getCacheList(String localKey) async {
    if (!localDataSource.has(localKey)) {
      await localDataSource.store(localKey, jsonEncode([]));
    }

    final cacheData = await localDataSource.get(localKey);
    List<dynamic> cacheList = jsonDecode(cacheData);

    return cacheList;
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
