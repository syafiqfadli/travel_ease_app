import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'set_page_state.dart';

class SetPageCubit extends Cubit<SetPageState> {
  SetPageCubit() : super(const SelectedPage(title: "Attractions", index: 0));

  void setPage(int selectedPage) async {
    if (selectedPage == 0) {
      emit(SelectedPage(title: "Attractions", index: selectedPage));
      return;
    }

    if (selectedPage == 1) {
      emit(SelectedPage(title: "Map", index: selectedPage));
      return;
    }

    if (selectedPage == 2) {
      emit(SelectedPage(title: "Favourite", index: selectedPage));
      return;
    }
  }
}
