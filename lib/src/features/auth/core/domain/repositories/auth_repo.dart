import 'package:dartz/dartz.dart';
import 'package:travel_ease_app/src/core/errors/failures.dart';
import 'package:travel_ease_app/src/features/auth/core/data/datasources/auth_datasource.dart';
import 'package:travel_ease_app/src/features/auth/core/domain/entities/auth_entity.dart';
import 'package:travel_ease_app/src/features/auth/core/domain/entities/token_entity.dart';

abstract class AuthRepo {
  Future<Either<Failure, TokenEntity>> logIn(AuthEntity authEntity);
  Future<Either<Failure, void>> logOut();
  Future<Either<Failure, String>> signUp(AuthEntity authEntity);
}

class AuthRepoImpl implements AuthRepo {
  final AuthDataSource authDataSource;

  AuthRepoImpl({required this.authDataSource});

  @override
  Future<Either<Failure, TokenEntity>> logIn(AuthEntity authEntity) async {
    final loginEither = await authDataSource.logIn(authEntity);

    return loginEither.fold(
      (failure) => Left(SystemFailure(message: failure.message)),
      (login) => Right(login),
    );
  }

  @override
  Future<Either<Failure, String>> signUp(AuthEntity authEntity) async {
    final signUpEither = await authDataSource.signUp(authEntity);

    return signUpEither.fold(
      (failure) => Left(SystemFailure(message: failure.message)),
      (message) => Right(message),
    );
  }

  @override
  Future<Either<Failure, void>> logOut() async {
    return await authDataSource.logOut();
  }
}
