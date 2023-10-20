import 'package:get_it/get_it.dart';
import 'package:travel_ease_app/src/features/auth/features/signup/presentation/bloc/signup_cubit.dart';

final signUpInjector = GetIt.instance;

void signUpInit() {
  //Bloc
  signUpInjector.registerLazySingleton<SignUpCubit>(
    () => SignUpCubit(authRepo: signUpInjector()),
  );
}
