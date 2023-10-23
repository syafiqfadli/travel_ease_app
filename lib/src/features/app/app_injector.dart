import 'package:get_it/get_it.dart';
import 'package:travel_ease_app/src/features/app/core/data/datasources/app_datasource.dart';
import 'package:travel_ease_app/src/features/app/core/domain/repositories/app_repo.dart';
import 'package:travel_ease_app/src/features/app/core/presentation/bloc/user_info_cubit.dart';
import 'package:travel_ease_app/src/features/app/features/attraction/presentation/bloc/nearby_places_cubit.dart';
import 'package:travel_ease_app/src/features/app/features/attraction/presentation/bloc/place_details_cubit.dart';
import 'package:travel_ease_app/src/features/app/features/favourite/presentation/bloc/favourite_list_cubit.dart';
import 'package:travel_ease_app/src/features/app/features/map/presentation/bloc/favourite_place_cubit.dart';
import 'package:travel_ease_app/src/features/app/features/map/presentation/bloc/marker_list_cubit.dart';
import 'package:travel_ease_app/src/features/app/features/map/presentation/bloc/search_places_cubit.dart';

final appInjector = GetIt.instance;

void appInit() {
  //DataSource
  appInjector.registerLazySingleton<AppDataSource>(
    () => AppDataSourceImpl(
      apiDataSource: appInjector(),
      localDataSource: appInjector(),
      authDataSource: appInjector(),
    ),
  );

  //Repositories
  appInjector.registerLazySingleton<AppRepo>(
    () => AppRepoImpl(appDataSource: appInjector()),
  );

  //Bloc
  appInjector.registerLazySingleton<UserInfoCubit>(
    () => UserInfoCubit(
      appRepo: appInjector(),
      tokenCubit: appInjector(),
    ),
  );

  appInjector.registerLazySingleton<SearchPlacesCubit>(
    () => SearchPlacesCubit(appRepo: appInjector()),
  );

  appInjector.registerLazySingleton<NearbyPlacesCubit>(
    () => NearbyPlacesCubit(appRepo: appInjector()),
  );

  appInjector.registerLazySingleton<PlaceDetailsCubit>(
    () => PlaceDetailsCubit(appRepo: appInjector()),
  );

  appInjector.registerLazySingleton<FavouritePlaceCubit>(
    () => FavouritePlaceCubit(appRepo: appInjector()),
  );

  appInjector.registerLazySingleton<FavouriteListCubit>(
    () => FavouriteListCubit(appRepo: appInjector()),
  );

  appInjector.registerFactory<MarkerListCubit>(
    () => MarkerListCubit(),
  );
}
