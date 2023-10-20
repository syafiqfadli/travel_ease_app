import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'set_page_state.dart';

class SetPageCubit extends Cubit<SetPageState> {
  SetPageCubit() : super(const SelectedPage(title: "Home", index: 0));

  void setPage(int selectedPage) async {
    if (selectedPage == 0) {
      emit(SelectedPage(title: "Home", index: selectedPage));
      return;
    }

    if (selectedPage == 1) {
      emit(SelectedPage(title: "Wishlist", index: selectedPage));
      return;
    }

    if (selectedPage == 2) {
      emit(SelectedPage(title: "Order", index: selectedPage));
      return;
    }

    if (selectedPage == 3) {
      emit(SelectedPage(title: "Profile", index: selectedPage));
      return;
    }
  }
}
