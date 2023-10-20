import 'package:dartz/dartz.dart';
import 'package:travel_ease_app/src/core/errors/failures.dart';
import 'package:travel_ease_app/src/features/app/core/data/datasources/app_datasource.dart';
import 'package:travel_ease_app/src/features/app/core/domain/entities/user_entity.dart';

abstract class AppRepo {
  Future<Either<Failure, UserEntity>> userInfo(String token);
}

class AppRepoImpl implements AppRepo {
  final AppDataSource appDataSource;

  AppRepoImpl({required this.appDataSource});

  @override
  Future<Either<Failure, UserEntity>> userInfo(String token) async {
    final userEither = await appDataSource.userInfo(token);

    return userEither.fold(
      (failure) => Left(SystemFailure(message: failure.message)),
      (user) => Right(user),
    );
  }
}
