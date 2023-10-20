import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_storage/get_storage.dart';
import 'package:travel_ease_app/src/features/auth/features/login/login_injector.dart';
import 'package:travel_ease_app/src/features/auth/features/login/presentation/bloc/token_cubit.dart';
import 'package:travel_ease_app/src/features/auth/features/login/presentation/pages/login_page.dart';
import 'package:travel_ease_app/src/src_injector.dart';

import 'src/features/app/core/presentation/pages/app_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await GetStorage.init();
  srcInit();
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  final TokenCubit tokenCubit = loginInjector<TokenCubit>();

  @override
  void initState() {
    super.initState();
    tokenCubit.checkToken();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: tokenCubit,
      child: MaterialApp(
        title: 'Travel Ease',
        home: tokenCubit.state != null ? const AppPage() : const LoginPage(),
      ),
    );
  }
}
