import 'package:bloc/bloc.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AppInfoCubit extends Cubit<PackageInfo> {
  AppInfoCubit()
      : super(
          PackageInfo(
            appName: 'Travel Ease',
            packageName: 'com.example.travel_ease_app',
            version: '1.0.0',
            buildNumber: '1',
          ),
        );

  void getAppInfo() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    emit(packageInfo);
  }
}
