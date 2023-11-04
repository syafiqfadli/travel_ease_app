import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travel_ease_app/src/core/app/presentation/bloc/app_info_cubit.dart';
import 'package:travel_ease_app/src/core/core_injector.dart';
import 'package:travel_ease_app/src/core/utils/constants.dart';
import 'package:travel_ease_app/src/core/utils/services.dart';
import 'package:travel_ease_app/src/features/app/app_injector.dart';
import 'package:travel_ease_app/src/features/app/core/presentation/bloc/set_page_cubit.dart';
import 'package:travel_ease_app/src/features/app/core/presentation/bloc/user_info_cubit.dart';
import 'package:travel_ease_app/src/features/app/core/presentation/widgets/drawer_item.dart';
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
  final SetPageCubit setPageCubit = SetPageCubit();
  final UserInfoCubit userInfoCubit = appInjector<UserInfoCubit>();
  final LogoutCubit logOutCubit = authInjector<LogoutCubit>();

  final List<Widget> pages = [
    const NearMePage(),
    const AtractionsPage(),
    const MapPage(),
    const FavouritePage(),
  ];

  @override
  void initState() {
    super.initState();
    appInfoCubit.getAppInfo();
  }

  @override
  Widget build(BuildContext context) {
    double safePadding = MediaQuery.of(context).padding.top;

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => setPageCubit),
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
              hasAction: false,
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
          child: GestureDetector(
            onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
            child: BlocBuilder<SetPageCubit, SetPageState>(
              builder: (context, state) {
                final selectedPage = (state as SelectedPage);

                return Scaffold(
                  appBar: AppBar(
                    title: Text(selectedPage.title.toUpperCase()),
                    backgroundColor: PrimaryColor.navyBlack,
                    actions: [
                      IconButton(
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        icon: const Icon(Icons.search),
                        onPressed: () {
                          setPageCubit.setPage(2);
                        },
                      )
                    ],
                  ),
                  drawer: Drawer(
                    child: DrawerItem(
                      safePadding: safePadding,
                      onLogout: _logout,
                    ),
                  ),
                  bottomNavigationBar: BottomNavigationBar(
                    type: BottomNavigationBarType.fixed,
                    backgroundColor: PrimaryColor.navyBlack,
                    selectedItemColor: PrimaryColor.pureWhite,
                    unselectedItemColor: PrimaryColor.pureWhite,
                    selectedLabelStyle: TextStyle(
                      color: PrimaryColor.pureWhite,
                    ),
                    showUnselectedLabels: false,
                    currentIndex: selectedPage.index,
                    onTap: (index) {
                      setPageCubit.setPage(index);
                    },
                    items: const [
                      BottomNavigationBarItem(
                        icon: Icon(Icons.room_outlined),
                        activeIcon: Icon(Icons.room),
                        label: "NEAR ME",
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.domain),
                        activeIcon: Icon(Icons.domain_outlined),
                        label: "ATTRACTIONS",
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.map_outlined),
                        activeIcon: Icon(Icons.map_rounded),
                        label: "MAP",
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.favorite_outline),
                        activeIcon: Icon(Icons.favorite_rounded),
                        label: "FAVOURITE",
                      ),
                    ],
                  ),
                  body: pages[selectedPage.index],
                );
              },
            ),
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
