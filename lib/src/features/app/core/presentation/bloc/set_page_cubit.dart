import 'package:bloc/bloc.dart';

class SetPageCubit extends Cubit<int?> {
  SetPageCubit() : super(null);

  void setPage(int selectedPage) async {
    emit(selectedPage);
  }

  void menuPage() {
    emit(null);
  }
}
