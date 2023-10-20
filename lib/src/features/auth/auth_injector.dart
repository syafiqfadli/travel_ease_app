import 'package:get_it/get_it.dart';
import 'package:travel_ease_app/src/features/auth/core/data/datasources/auth_datasource.dart';
import 'package:travel_ease_app/src/features/auth/core/domain/repositories/auth_repo.dart';
import 'package:travel_ease_app/src/features/auth/features/login/login_injector.dart';
import 'package:travel_ease_app/src/features/auth/features/logout/logout_injector.dart';
import 'package:travel_ease_app/src/features/auth/features/signup/signup_injector.dart';

final authInjector = GetIt.instance;

void authInit() {
  //DataSource
  authInjector.registerLazySingleton<AuthDataSource>(
    () => AuthDataSourceImpl(
      apiDataSource: authInjector(),
      localDataSource: authInjector(),
    ),
  );

  //Repositories
  authInjector.registerLazySingleton<AuthRepo>(
    () => AuthRepoImpl(authDataSource: authInjector()),
  );

  loginInit();
  signUpInit();
  logOutInit();
}
