import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travel_ease_app/src/core/utils/constants.dart';
import 'package:travel_ease_app/src/features/app/app_injector.dart';
import 'package:travel_ease_app/src/features/app/core/presentation/bloc/cubit/set_page_cubit.dart';
import 'package:travel_ease_app/src/features/app/core/presentation/bloc/cubit/user_info_cubit.dart';
import 'package:travel_ease_app/src/features/app/features/home/presentation/pages/home_page.dart';
import 'package:travel_ease_app/src/features/auth/features/login/presentation/pages/login_page.dart';
import 'package:travel_ease_app/src/features/auth/features/logout/logout_injector.dart';
import 'package:travel_ease_app/src/features/auth/features/logout/presentation/bloc/logout_cubit.dart';

class AppPage extends StatefulWidget {
  const AppPage({super.key});

  @override
  State<AppPage> createState() => _AppPageState();
}

class _AppPageState extends State<AppPage> {
  final SetPageCubit setPageCubit = SetPageCubit();
  final UserInfoCubit userInfoCubit = appInjector<UserInfoCubit>();
  final LogOutCubit logOutCubit = logOutInjector<LogOutCubit>();

  final List<Widget> pages = [
    const HomePage(),
    const Scaffold(),
    const Scaffold(),
    const Scaffold(),
  ];

  @override
  void initState() {
    super.initState();
    userInfoCubit.getUser();
  }

  @override
  Widget build(BuildContext context) {
    double safePadding = MediaQuery.of(context).padding.top;

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => setPageCubit),
        BlocProvider.value(value: userInfoCubit),
        BlocProvider.value(value: logOutCubit),
      ],
      child: BlocListener<UserInfoCubit, UserInfoState>(
        listener: (context, state) {
          if (state is UserInfoError) {
            // _logOut();
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
                    title: Text(selectedPage.title),
                    backgroundColor: PrimaryColor.navyBlack,
                    actions: [
                      IconButton(
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        icon: const Icon(Icons.shopping_cart_outlined),
                        onPressed: () {},
                      )
                    ],
                  ),
                  drawer: Drawer(
                    child: Column(
                      children: [
                        SizedBox(height: safePadding + 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            const Icon(
                              Icons.account_circle,
                              size: 80,
                            ),
                            BlocBuilder<UserInfoCubit, UserInfoState>(
                              builder: (context, state) {
                                if (state is UserInfoLoaded) {
                                  final user = state.userEntity;
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(user.displayName),
                                      Text(user.email),
                                    ],
                                  );
                                }
                                return const Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("User"),
                                    Text("user@gmail.com"),
                                  ],
                                );
                              },
                            )
                          ],
                        ),
                        const SizedBox(height: 60),
                        ListTile(
                          leading: Container(
                            height: 45,
                            width: 45,
                            decoration: BoxDecoration(
                              color: PrimaryColor.lightGrey,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10)),
                            ),
                            child: const Icon(Icons.logout),
                          ),
                          title: const Text("Log Out"),
                          onTap: _logOut,
                        ),
                      ],
                    ),
                  ),
                  bottomNavigationBar: Theme(
                    data: Theme.of(context).copyWith(
                      canvasColor: PrimaryColor.navyBlack,
                    ),
                    child: BottomNavigationBar(
                      currentIndex: selectedPage.index,
                      onTap: (index) {
                        setPageCubit.setPage(index);
                      },
                      items: const [
                        BottomNavigationBarItem(
                          icon: Icon(Icons.home_outlined),
                          activeIcon: Icon(Icons.home),
                          label: "HOME",
                        ),
                        BottomNavigationBarItem(
                          icon: Icon(Icons.favorite_border),
                          activeIcon: Icon(Icons.favorite),
                          label: "WISHLIST",
                        ),
                        BottomNavigationBarItem(
                          icon: Icon(Icons.shopping_bag_outlined),
                          activeIcon: Icon(Icons.shopping_bag),
                          label: "ORDER",
                        ),
                        BottomNavigationBarItem(
                          icon: Icon(Icons.person_outline_outlined),
                          activeIcon: Icon(Icons.person),
                          label: "PROFILE",
                        ),
                      ],
                    ),
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

  void _logOut() {
    logOutCubit.logOut();
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (context) => const LoginPage(),
      ),
      (Route<dynamic> route) => false,
    );
  }
}
