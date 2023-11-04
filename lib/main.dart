import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get_storage/get_storage.dart';
import 'package:travel_ease_app/src/core/app/presentation/widgets/loading.dart';
import 'package:travel_ease_app/src/core/core_injector.dart';
import 'package:travel_ease_app/src/core/utils/services.dart';
import 'package:travel_ease_app/src/features/app/core/presentation/bloc/user_info_cubit.dart';
import 'package:travel_ease_app/src/features/auth/auth_injector.dart';
import 'package:travel_ease_app/src/features/auth/features/login/presentation/bloc/token_cubit.dart';
import 'package:travel_ease_app/src/features/auth/features/login/presentation/pages/login_page.dart';
import 'package:travel_ease_app/src/features/auth/features/logout/presentation/bloc/logout_cubit.dart';
import 'package:travel_ease_app/src/src_injector.dart';

import 'src/features/app/core/presentation/pages/app_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await Geolocator.requestPermission();
  await GetStorage.init();
  srcInit();
  runApp(
    const MaterialApp(
      title: 'Travel Ease',
      debugShowCheckedModeBanner: false,
      home: MainApp(),
    ),
  );
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  final TokenCubit tokenCubit = authInjector<TokenCubit>();
  final UserInfoCubit userInfoCubit = coreInjector<UserInfoCubit>();
  final LogoutCubit logoutCubit = authInjector<LogoutCubit>();

  @override
  void initState() {
    super.initState();
    tokenCubit.checkToken();

    if (tokenCubit.state != null) {
      userInfoCubit.getUser();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: tokenCubit),
        BlocProvider.value(value: userInfoCubit),
        BlocProvider.value(value: logoutCubit),
      ],
      child: BlocListener<UserInfoCubit, UserInfoState>(
        listener: (context, state) async {
          if (state is UserInfoError) {
            logoutCubit.logout();

            await DialogService.showMessage(
              title: 'Error',
              message: state.message,
              hasAction: false,
              icon: Icons.error,
              context: context,
            );
          }
        },
        child: BlocBuilder<UserInfoCubit, UserInfoState>(
          builder: (context, state) {
            if (state is UserInfoLoaded) {
              return const AppPage();
            }

            if (state is UserInfoLoading) {
              return const Scaffold(
                body: CustomLoading(),
              );
            }

            return const LoginPage();
          },
        ),
      ),
    );
  }
}
