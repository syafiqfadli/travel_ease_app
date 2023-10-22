import 'package:get_it/get_it.dart';
import 'package:travel_ease_app/src/features/app/core/data/datasources/app_datasource.dart';
import 'package:travel_ease_app/src/features/app/core/domain/repositories/app_repo.dart';
import 'package:travel_ease_app/src/features/app/core/presentation/bloc/cubit/user_info_cubit.dart';
import 'package:travel_ease_app/src/features/app/features/home/data/datasources/home_datasource.dart';
import 'package:travel_ease_app/src/features/app/features/home/domain/repositories/home_repo.dart';
import 'package:travel_ease_app/src/features/app/features/home/presentation/bloc/places_cubit.dart';

final appInjector = GetIt.instance;

void appInit() {
  //DataSource
  appInjector.registerLazySingleton<AppDataSource>(
    () => AppDataSourceImpl(apiDataSource: appInjector()),
  );

  appInjector.registerLazySingleton<HomeDataSource>(
    () => HomeDataSourceImpl(apiDataSource: appInjector()),
  );

  //Repositories
  appInjector.registerLazySingleton<AppRepo>(
    () => AppRepoImpl(appDataSource: appInjector()),
  );

  appInjector.registerLazySingleton<HomeRepo>(
    () => HomeRepoImpl(homeDataSource: appInjector()),
  );

  //Bloc
  appInjector.registerLazySingleton<UserInfoCubit>(
    () => UserInfoCubit(
      appRepo: appInjector(),
      tokenCubit: appInjector(),
    ),
  );

  appInjector.registerFactory<PlacesCubit>(
    () => PlacesCubit(homeRepo: appInjector()),
  );
}
