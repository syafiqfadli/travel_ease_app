import 'package:get_it/get_it.dart';
import 'package:travel_ease_app/src/features/auth/core/data/datasources/auth_datasource.dart';
import 'package:travel_ease_app/src/features/auth/core/domain/repositories/auth_repo.dart';
import 'package:travel_ease_app/src/features/auth/features/login/presentation/bloc/login_cubit.dart';
import 'package:travel_ease_app/src/features/auth/features/login/presentation/bloc/token_cubit.dart';
import 'package:travel_ease_app/src/features/auth/features/logout/presentation/bloc/logout_cubit.dart';
import 'package:travel_ease_app/src/features/auth/features/reset_password/presentation/bloc/reset_password_cubit.dart';
import 'package:travel_ease_app/src/features/auth/features/signup/presentation/bloc/signup_cubit.dart';

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

  //Bloc
  authInjector.registerLazySingleton<TokenCubit>(
    () => TokenCubit(localDataSource: authInjector()),
  );

  authInjector.registerLazySingleton<LoginCubit>(
    () => LoginCubit(
      authRepo: authInjector(),
      userInfoCubit: authInjector(),
      tokenCubit: authInjector(),
    ),
  );

  authInjector.registerLazySingleton<SignUpCubit>(
    () => SignUpCubit(authRepo: authInjector()),
  );

  authInjector.registerLazySingleton<LogoutCubit>(
    () => LogoutCubit(
      authRepo: authInjector(),
      tokenCubit: authInjector(),
    ),
  );

  authInjector.registerLazySingleton<ResetPasswordCubit>(
    () => ResetPasswordCubit(authRepo: authInjector()),
  );
}
