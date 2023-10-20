import 'package:bloc/bloc.dart';

class ShowPasswordCubit extends Cubit<bool> {
  ShowPasswordCubit() : super(false);

  bool isShow = false;

  void showPassword() {
    emit(!isShow);
    isShow = !isShow;
  }
}
