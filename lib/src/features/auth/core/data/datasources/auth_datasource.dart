import 'package:dartz/dartz.dart';
import 'package:travel_ease_app/src/core/app/data/datasources/api_datasource.dart';
import 'package:travel_ease_app/src/core/app/data/datasources/local_datasource.dart';
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
    final apiEither = await apiDataSource.post(
      Uri.parse(ApiUrl.logIn),
      headers: {'Content-Type': 'application/json'},
      body: {
        "email": authEntity.email,
        "password": authEntity.password,
      },
    );

    return apiEither.fold(
      (failure) async {
        await localDataSource.remove(LocalKey.tokenKey);
        return Left(SystemFailure(message: failure.message));
      },
      (response) async {
        if (!response.isSuccess) {
          await localDataSource.remove(LocalKey.tokenKey);
          return Left(SystemFailure(message: response.message));
        }

        final tokenModel = TokenModel.fromJson(response.data);
        await localDataSource.store(LocalKey.tokenKey, response.data);

        return Right(tokenModel);
      },
    );
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

    return apiEither.fold(
      (failure) async {
        return Left(SystemFailure(message: failure.message));
      },
      (response) async {
        if (!response.isSuccess) {
          return Left(SystemFailure(message: response.message));
        }

        return Right(response.message);
      },
    );
  }

  @override
  Future<Either<Failure, void>> logout() async {
    await localDataSource.remove(LocalKey.tokenKey);
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

    return apiEither.fold(
      (failure) async {
        return Left(SystemFailure(message: failure.message));
      },
      (response) async {
        if (!response.isSuccess) {
          return Left(SystemFailure(message: response.message));
        }

        return Right(response.message);
      },
    );
  }
}
