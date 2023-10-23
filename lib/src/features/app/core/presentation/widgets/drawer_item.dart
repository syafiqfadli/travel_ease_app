import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travel_ease_app/src/core/utils/constants.dart';
import 'package:travel_ease_app/src/features/app/core/presentation/bloc/user_info_cubit.dart';

class DrawerItem extends StatelessWidget {
  final double safePadding;
  final void Function() onLogout;

  const DrawerItem({
    super.key,
    required this.onLogout,
    required this.safePadding,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: safePadding + 10),
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
                        user.displayName,
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
            leading: const Icon(Icons.logout),
            title: const Text("Log Out"),
            onTap: onLogout,
          ),
        ],
      ),
    );
  }
}
