import 'package:get_it/get_it.dart';
import 'package:travel_ease_app/src/features/auth/features/logout/presentation/bloc/logout_cubit.dart';

final logOutInjector = GetIt.instance;

void logOutInit() {
  //Bloc
  logOutInjector.registerLazySingleton<LogOutCubit>(
    () => LogOutCubit(authRepo: logOutInjector()),
  );
}
