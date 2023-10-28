import 'package:dartz/dartz.dart';
import 'package:travel_ease_app/src/core/errors/failures.dart';
import 'package:travel_ease_app/src/features/app/core/domain/entities/place/place_entity.dart';
import 'package:travel_ease_app/src/features/app/features/map/data/datasources/map_datasource.dart';

abstract class MapRepo {
  Future<Either<Failure, List<PlaceEntity>>> searchGooglePlaces(String query);
}

class MapRepoImpl implements MapRepo {
  final MapDataSource mapDataSource;

  MapRepoImpl({required this.mapDataSource});

  @override
  Future<Either<Failure, List<PlaceEntity>>> searchGooglePlaces(
    String query,
  ) async {
    final placesEither = await mapDataSource.searchGooglePlaces(query);

    return placesEither.fold(
      (failure) => Left(SystemFailure(message: failure.message)),
      (places) => Right(places),
    );
  }
}
