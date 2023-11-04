import 'package:dartz/dartz.dart';
import 'package:travel_ease_app/src/core/app/data/datasources/api_datasource.dart';
import 'package:travel_ease_app/src/core/app/data/datasources/local_datasource.dart';
import 'package:travel_ease_app/src/core/app/data/models/response_model.dart';
import 'package:travel_ease_app/src/core/errors/failures.dart';
import 'package:travel_ease_app/src/core/utils/constants.dart';
import 'package:travel_ease_app/src/features/app/core/data/models/place/place_model.dart';

abstract class MapDataSource {
  Future<Either<Failure, List<PlaceModel>>> searchGooglePlaces(String query);
}

class MapDataSourceImpl implements MapDataSource {
  final ApiDataSource apiDataSource;
  final LocalDataSource localDataSource;

  MapDataSourceImpl({
    required this.apiDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, List<PlaceModel>>> searchGooglePlaces(
    String query,
  ) async {
    final apiEither = await apiDataSource.get(
      Uri.parse('${ApiUrl.placeGoogleText}?query=$query'),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    final response = apiEither.getOrElse(() => ResponseModel.empty);

    if (!response.isSuccess) {
      return Left(SystemFailure(message: response.message));
    }

    final placesModel = PlaceModel.fromList(response.data['results']);

    return Right(placesModel);
  }
}
