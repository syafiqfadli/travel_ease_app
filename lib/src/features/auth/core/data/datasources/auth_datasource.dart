import 'package:dartz/dartz.dart';
import 'package:travel_ease_app/src/core/app/data/datasources/api_datasource.dart';
import 'package:travel_ease_app/src/core/app/data/datasources/local_datasource.dart';
import 'package:travel_ease_app/src/core/app/domain/entities/response_entity.dart';
import 'package:travel_ease_app/src/core/errors/failures.dart';
import 'package:travel_ease_app/src/core/utils/constants.dart';
import 'package:travel_ease_app/src/features/auth/core/data/models/token_model.dart';
import 'package:travel_ease_app/src/features/auth/core/domain/entities/auth_entity.dart';

abstract class AuthDataSource {
  Future<Either<Failure, TokenModel>> logIn(AuthEntity authEntity);
  Future<Either<Failure, void>> logout();
  Future<Either<Failure, String>> signUp(AuthEntity authEntity);
  Future<Either<Failure, String>> resetPassword(AuthEntity authEntity);
}

class AuthDataSourceImpl implements AuthDataSource {
  final ApiDataSource apiDataSource;
  final LocalDataSource localDataSource;

  AuthDataSourceImpl({
    required this.apiDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, TokenModel>> logIn(AuthEntity authEntity) async {
    try {
      final apiEither = await apiDataSource.post(
        Uri.parse(ApiUrl.logIn),
        headers: {'Content-Type': 'application/json'},
        body: {
          "email": authEntity.email,
          "password": authEntity.password,
        },
      );

      final response = apiEither.getOrElse(() => ResponseEntity.empty);

      if (!response.isSuccess) {
        await localDataSource.remove(LocalKey.tokenKey);
        return Left(SystemFailure(message: response.message));
      }

      final tokenModel = TokenModel.fromJson(response.data);
      await localDataSource.store(LocalKey.tokenKey, response.data);

      return Right(tokenModel);
    } catch (error) {
      return Left(SystemFailure(message: error.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> signUp(AuthEntity authEntity) async {
    final apiEither = await apiDataSource.post(
      Uri.parse(ApiUrl.signUp),
      headers: {'Content-Type': 'application/json'},
      body: {
        "email": authEntity.email,
        "password": authEntity.password,
        "displayName": authEntity.displayName,
      },
    );

    final response = apiEither.getOrElse(() => ResponseEntity.empty);

    if (!response.isSuccess) {
      return Left(SystemFailure(message: response.message));
    }

    return Right(response.message);
  }

  @override
  Future<Either<Failure, void>> logout() async {
    await localDataSource.reset();
    return const Right(null);
  }

  @override
  Future<Either<Failure, String>> resetPassword(AuthEntity authEntity) async {
    final apiEither = await apiDataSource.patch(
      Uri.parse(ApiUrl.resetPassword),
      headers: {'Content-Type': 'application/json'},
      body: {
        "email": authEntity.email,
        "password": authEntity.password,
      },
    );

    final response = apiEither.getOrElse(() => ResponseEntity.empty);

    if (!response.isSuccess) {
      return Left(SystemFailure(message: response.message));
    }

    return Right(response.message);
  }
}
