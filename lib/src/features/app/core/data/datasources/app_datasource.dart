import 'package:dartz/dartz.dart';
import 'package:travel_ease_app/src/core/app/data/datasources/api_datasource.dart';
import 'package:travel_ease_app/src/core/app/domain/entities/response_entity.dart';
import 'package:travel_ease_app/src/core/errors/failures.dart';
import 'package:travel_ease_app/src/core/utils/constants.dart';
import 'package:travel_ease_app/src/features/app/core/data/models/user_model.dart';

abstract class AppDataSource {
  Future<Either<Failure, UserModel>> userInfo(String token);
}

class AppDataSourceImpl implements AppDataSource {
  final ApiDataSource apiDataSource;

  AppDataSourceImpl({
    required this.apiDataSource,
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
      return Left(SystemFailure(message: response.message));
    }

    final userModel = UserModel.fromJson(response.data);

    return Right(userModel);
  }
}
