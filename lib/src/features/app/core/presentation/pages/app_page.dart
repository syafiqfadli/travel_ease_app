import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travel_ease_app/src/core/app/presentation/bloc/app_info_cubit.dart';
import 'package:travel_ease_app/src/core/core_injector.dart';
import 'package:travel_ease_app/src/core/utils/constants.dart';
import 'package:travel_ease_app/src/core/utils/helpers.dart';
import 'package:travel_ease_app/src/core/utils/services.dart';
import 'package:travel_ease_app/src/features/app/app_injector.dart';
import 'package:travel_ease_app/src/features/app/core/presentation/bloc/set_page_cubit.dart';
import 'package:travel_ease_app/src/features/app/core/presentation/bloc/user_info_cubit.dart';
import 'package:travel_ease_app/src/features/app/core/presentation/widgets/drawer_item.dart';
import 'package:travel_ease_app/src/features/app/core/presentation/widgets/menu_card.dart';
import 'package:travel_ease_app/src/features/app/features/attractions/presentation/pages/attractions_page.dart';
import 'package:travel_ease_app/src/features/app/features/favourite/presentation/pages/favourite_page.dart';
import 'package:travel_ease_app/src/features/app/features/map/presentation/pages/map_page.dart';
import 'package:travel_ease_app/src/features/app/features/near_me/presentation/pages/near_me_page.dart';
import 'package:travel_ease_app/src/features/auth/auth_injector.dart';
import 'package:travel_ease_app/src/features/auth/features/login/presentation/pages/login_page.dart';
import 'package:travel_ease_app/src/features/auth/features/logout/presentation/bloc/logout_cubit.dart';

class AppPage extends StatefulWidget {
  const AppPage({super.key});

  @override
  State<AppPage> createState() => _AppPageState();
}

class _AppPageState extends State<AppPage> {
  final AppInfoCubit appInfoCubit = coreInjector<AppInfoCubit>();
  final SetPageCubit setPageCubit = appInjector<SetPageCubit>();
  final UserInfoCubit userInfoCubit = appInjector<UserInfoCubit>();
  final LogoutCubit logOutCubit = authInjector<LogoutCubit>();

  final List pages = [
    {
      'title': 'Near Me',
      'icon': Icons.room,
    },
    {
      'title': 'Attractions',
      'icon': Icons.domain,
    },
    {
      'title': 'Map',
      'icon': Icons.map,
    },
    {
      'title': 'Favourite',
      'icon': Icons.favorite,
    },
  ];

  @override
  void initState() {
    super.initState();
    appInfoCubit.getAppInfo();
  }

  @override
  Widget build(BuildContext context) {
    const TextStyle titleStyle = TextStyle(
      fontSize: 30,
      fontWeight: FontWeight.bold,
    );

    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: setPageCubit),
        BlocProvider.value(value: userInfoCubit),
        BlocProvider.value(value: logOutCubit),
        BlocProvider.value(value: appInfoCubit),
      ],
      child: BlocListener<UserInfoCubit, UserInfoState>(
        listener: (context, state) async {
          if (state is UserInfoError) {
            await DialogService.showMessage(
              title: 'Error',
              message: state.message,
              icon: Icons.error,
              context: context,
            );

            _logout();
          }
        },
        child: WillPopScope(
          onWillPop: () {
            return Future.value(true);
          },
          child: BlocBuilder<SetPageCubit, int?>(
            builder: (context, state) {
              return Scaffold(
                appBar: AppBar(
                  title: Text(state != null ? pages[state]['title'] : 'Menu'),
                  backgroundColor: PrimaryColor.navyBlack,
                ),
                drawer: const Drawer(
                  child: DrawerItem(),
                ),
                body: BlocBuilder<SetPageCubit, int?>(
                  builder: (context, state) {
                    if (state == 0) {
                      return const NearMePage();
                    }

                    if (state == 1) {
                      return const AttractionsPage();
                    }

                    if (state == 2) {
                      return const MapPage();
                    }

                    if (state == 3) {
                      return const FavouritePage();
                    }

                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 50,
                            horizontal: 20,
                          ),
                          child: Row(
                            children: [
                              Image.asset(
                                'assets/images/logo.png',
                                height: 70,
                              ),
                              const SizedBox(width: 10),
                              const Text('Hi, ', style: titleStyle),
                              BlocBuilder<UserInfoCubit, UserInfoState>(
                                builder: (context, state) {
                                  if (state is UserInfoLoaded) {
                                    return Text(
                                      "${StringHelper.capitalizeFirstLetter(state.userEntity.displayName)}!",
                                      style: titleStyle,
                                    );
                                  }

                                  return const Text(
                                    'User',
                                    style: titleStyle,
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                        GridView.builder(
                            shrinkWrap: true,
                            physics: const BouncingScrollPhysics(
                              parent: AlwaysScrollableScrollPhysics(),
                            ),
                            itemCount: pages.length,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisExtent: 220,
                            ),
                            itemBuilder: (context, index) {
                              final item = pages[index];

                              return MenuCard(
                                index: index,
                                title: item['title'],
                                icon: item['icon'],
                              );
                            }),
                      ],
                    );
                  },
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  void _logout() {
    logOutCubit.logout();
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (context) => const LoginPage(),
      ),
      (Route<dynamic> route) => false,
    );
  }
}
