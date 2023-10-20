import 'package:get_it/get_it.dart';
import 'package:travel_ease_app/src/features/auth/features/login/presentation/bloc/login_cubit.dart';
import 'package:travel_ease_app/src/features/auth/features/login/presentation/bloc/token_cubit.dart';

final loginInjector = GetIt.instance;

void loginInit() {
  //Bloc
  loginInjector.registerLazySingleton<TokenCubit>(
    () => TokenCubit(localDataSource: loginInjector()),
  );

  loginInjector.registerLazySingleton<LoginCubit>(
    () => LoginCubit(
      authRepo: loginInjector(),
      tokenCubit: loginInjector(),
    ),
  );
}
