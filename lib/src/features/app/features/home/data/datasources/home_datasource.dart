import 'package:dartz/dartz.dart';
import 'package:travel_ease_app/src/core/app/data/datasources/api_datasource.dart';
import 'package:travel_ease_app/src/core/app/domain/entities/response_entity.dart';
import 'package:travel_ease_app/src/core/errors/failures.dart';
import 'package:travel_ease_app/src/core/utils/constants.dart';
import 'package:travel_ease_app/src/features/app/features/home/data/models/place_model.dart';

abstract class HomeDataSource {
  Future<Either<Failure, List<PlaceModel>>> searchPlaces(String query);
}

class HomeDataSourceImpl implements HomeDataSource {
  final ApiDataSource apiDataSource;

  HomeDataSourceImpl({
    required this.apiDataSource,
  });

  @override
  Future<Either<Failure, List<PlaceModel>>> searchPlaces(String query) async {
    final apiEither = await apiDataSource.get(
      Uri.parse('${ApiUrl.placeGoogle}?query=$query'),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    final response = apiEither.getOrElse(() => ResponseEntity.empty);

    if (!response.isSuccess) {
      return Left(SystemFailure(message: response.message));
    }

    final placesModel =
        PlaceModel.fromList(response.data['results'] ?? response.data);

    return Right(placesModel);
  }
}
