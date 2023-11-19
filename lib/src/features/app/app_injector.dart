import 'package:get_it/get_it.dart';
import 'package:google_map_polyline_new/google_map_polyline_new.dart';
import 'package:travel_ease_app/src/features/app/core/data/datasources/app_datasource.dart';
import 'package:travel_ease_app/src/features/app/core/domain/repositories/app_repo.dart';
import 'package:travel_ease_app/src/features/app/core/presentation/bloc/set_page_cubit.dart';
import 'package:travel_ease_app/src/features/app/core/presentation/bloc/user_info_cubit.dart';
import 'package:travel_ease_app/src/features/app/features/attractions/presentation/bloc/attraction_cubit.dart';
import 'package:travel_ease_app/src/features/app/features/attractions/presentation/bloc/attraction_details_cubit.dart';
import 'package:travel_ease_app/src/features/app/features/favourite/presentation/bloc/favourite_list_cubit.dart';
import 'package:travel_ease_app/src/features/app/features/map/data/datasources/map_datasource.dart';
import 'package:travel_ease_app/src/features/app/features/map/domain/repositories/map_repo.dart';
import 'package:travel_ease_app/src/features/app/features/map/presentation/bloc/calculate_route_cubit.dart';
import 'package:travel_ease_app/src/features/app/features/map/presentation/bloc/marker_list_cubit.dart';
import 'package:travel_ease_app/src/features/app/features/map/presentation/bloc/place_list_cubit.dart';
import 'package:travel_ease_app/src/features/app/features/map/presentation/bloc/polyline_list_cubit.dart';
import 'package:travel_ease_app/src/features/app/features/map/presentation/bloc/route_cubit.dart';
import 'package:travel_ease_app/src/features/app/features/map/presentation/bloc/search_places_cubit.dart';
import 'package:travel_ease_app/src/features/app/features/map/presentation/bloc/select_place_cubit.dart';
import 'package:travel_ease_app/src/features/app/features/near_me/presentation/bloc/nearby_places_cubit.dart';
import 'package:travel_ease_app/src/features/app/features/near_me/presentation/bloc/place_details_cubit.dart';

final appInjector = GetIt.instance;

void appInit() {
  //DataSource
  appInjector.registerLazySingleton<AppDataSource>(
    () => AppDataSourceImpl(
      apiDataSource: appInjector(),
      localDataSource: appInjector(),
    ),
  );

  appInjector.registerLazySingleton<MapDataSource>(
    () => MapDataSourceImpl(
      apiDataSource: appInjector(),
      localDataSource: appInjector(),
    ),
  );

  //Repositories
  appInjector.registerLazySingleton<AppRepo>(
    () => AppRepoImpl(appDataSource: appInjector()),
  );

  appInjector.registerLazySingleton<MapRepo>(
    () => MapRepoImpl(mapDataSource: appInjector()),
  );

  //Bloc
  appInjector.registerLazySingleton<SetPageCubit>(() => SetPageCubit());

  appInjector.registerLazySingleton<UserInfoCubit>(
    () => UserInfoCubit(
      appRepo: appInjector(),
      tokenCubit: appInjector(),
    ),
  );

  appInjector.registerLazySingleton<SearchPlacesCubit>(
    () => SearchPlacesCubit(mapRepo: appInjector()),
  );

  appInjector.registerLazySingleton<NearbyPlacesCubit>(
    () => NearbyPlacesCubit(appRepo: appInjector()),
  );

  appInjector.registerLazySingleton<PlaceDetailsCubit>(
    () => PlaceDetailsCubit(appRepo: appInjector()),
  );

  appInjector.registerLazySingleton<FavouriteListCubit>(
    () => FavouriteListCubit(
      appRepo: appInjector(),
      userInfoCubit: appInjector(),
    ),
  );

  appInjector.registerLazySingleton<SelectPlaceCubit>(
    () => SelectPlaceCubit(
      appRepo: appInjector(),
      userInfoCubit: appInjector(),
    ),
  );

  appInjector.registerLazySingleton<AttractionCubit>(
    () => AttractionCubit(),
  );

  appInjector.registerLazySingleton<MarkerListCubit>(
    () => MarkerListCubit(
      appRepo: appInjector(),
      placeListCubit: appInjector(),
    ),
  );

  appInjector.registerLazySingleton<PolylineListCubit>(
    () => PolylineListCubit(),
  );

  appInjector.registerLazySingleton<RouteCubit>(
    () => RouteCubit(
      googleMapPolyline: GoogleMapPolyline(
        apiKey: "AIzaSyC1GDs86spPY_yXzohd0CNZ0fjlYH4XBvE",
      ),
    ),
  );

  appInjector.registerFactory<CalculateRouteCubit>(
    () => CalculateRouteCubit(
      appRepo: appInjector(),
      markerListCubit: appInjector(),
      selectPlaceCubit: appInjector(),
      polylineListCubit: appInjector(),
      placeListCubit: appInjector(),
      routeCubit: appInjector(),
    ),
  );

  appInjector.registerLazySingleton<PlaceListCubit>(
    () => PlaceListCubit(),
  );

  appInjector.registerLazySingleton<AttractionDetailsCubit>(
    () => AttractionDetailsCubit(
      appRepo: appInjector(),
    ),
  );
}
