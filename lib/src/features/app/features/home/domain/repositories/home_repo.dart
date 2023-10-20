import 'package:dartz/dartz.dart';
import 'package:travel_ease_app/src/core/errors/failures.dart';
import 'package:travel_ease_app/src/features/app/core/domain/entities/place/place_entity.dart';
import 'package:travel_ease_app/src/features/app/features/home/data/datasources/home_datasource.dart';

abstract class HomeRepo {
  Future<Either<Failure, List<PlaceEntity>>> searchPlaces(String query);
}

class HomeRepoImpl implements HomeRepo {
  final HomeDataSource homeDataSource;

  HomeRepoImpl({required this.homeDataSource});

  @override
  Future<Either<Failure, List<PlaceEntity>>> searchPlaces(String query) async {
    final placesEither = await homeDataSource.searchPlaces(query);

    return placesEither.fold(
      (failure) => Left(SystemFailure(message: failure.message)),
      (places) => Right(places),
    );
  }
}
