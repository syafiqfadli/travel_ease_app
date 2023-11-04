import 'package:get_it/get_it.dart';
import 'package:get_storage/get_storage.dart';
import 'package:travel_ease_app/src/core/app/data/datasources/api_datasource.dart';
import 'package:travel_ease_app/src/core/app/data/datasources/local_datasource.dart';
import 'package:travel_ease_app/src/core/app/presentation/bloc/app_info_cubit.dart';

final coreInjector = GetIt.instance;

void coreInit() {
  //DataSource
  coreInjector.registerLazySingleton<ApiDataSource>(
    () => ApiDataSourceImpl(),
  );

  coreInjector.registerLazySingleton<LocalDataSource>(
    () => LocalDataSourceImpl(storage: GetStorage()),
  );

  //Bloc
  coreInjector.registerLazySingleton<AppInfoCubit>(
    () => AppInfoCubit(),
  );
}
