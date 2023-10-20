import 'package:travel_ease_app/src/features/app/app_injector.dart';
import 'package:travel_ease_app/src/features/auth/auth_injector.dart';

void featureInit() {
  authInit();
  appInit();
}
