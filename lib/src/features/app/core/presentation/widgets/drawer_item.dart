import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:travel_ease_app/src/core/app/presentation/bloc/app_info_cubit.dart';
import 'package:travel_ease_app/src/core/utils/constants.dart';
import 'package:travel_ease_app/src/core/utils/helpers.dart';
import 'package:travel_ease_app/src/features/app/core/presentation/bloc/set_page_cubit.dart';
import 'package:travel_ease_app/src/features/app/core/presentation/bloc/user_info_cubit.dart';
import 'package:travel_ease_app/src/features/auth/features/login/presentation/pages/login_page.dart';
import 'package:travel_ease_app/src/features/auth/features/logout/presentation/bloc/logout_cubit.dart';

class DrawerItem extends StatefulWidget {
  const DrawerItem({super.key});

  @override
  State<DrawerItem> createState() => _DrawerItemState();
}

class _DrawerItemState extends State<DrawerItem> {
  @override
  Widget build(BuildContext context) {
    final double safePadding = MediaQuery.of(context).padding.top;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: safePadding + 10),
          Row(
            children: [
              Image.asset(
                'assets/images/logo.png',
                height: 70,
              ),
              const SizedBox(width: 10),
              const Text(
                'Travel Ease',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 30),
            child: BlocBuilder<UserInfoCubit, UserInfoState>(
              builder: (context, state) {
                if (state is UserInfoLoaded) {
                  final user = state.userEntity;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        StringHelper.capitalizeFirstLetter(user.displayName),
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
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
            ),
          ),
          Divider(color: PrimaryColor.navyBlack),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text("Menu"),
            onTap: _menuPage,
          ),
          ListTile(
            leading: const Icon(Icons.room),
            title: const Text("Near Me"),
            onTap: () => _navigatePage(0),
          ),
          ListTile(
            leading: const Icon(Icons.domain),
            title: const Text("Attractions"),
            onTap: () => _navigatePage(1),
          ),
          ListTile(
            leading: const Icon(Icons.map),
            title: const Text("Map"),
            onTap: () => _navigatePage(2),
          ),
          ListTile(
            leading: const Icon(Icons.favorite),
            title: const Text("Favourite"),
            onTap: () => _navigatePage(3),
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text("Log Out"),
            onTap: _logout,
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: BlocBuilder<AppInfoCubit, PackageInfo>(
              builder: (context, state) {
                return Text('Version ${state.version}');
              },
            ),
          ),
        ],
      ),
    );
  }

  void _logout() {
    context.read<LogoutCubit>().logout();
    context.read<SetPageCubit>().menuPage();

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (context) => const LoginPage(),
      ),
      (Route<dynamic> route) => false,
    );
  }

  void _navigatePage(int index) {
    Navigator.of(context).pop();
    context.read<SetPageCubit>().setPage(index);
  }

  void _menuPage() {
    Navigator.of(context).pop();
    context.read<SetPageCubit>().menuPage();
  }
}
