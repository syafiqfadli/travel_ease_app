import 'package:bloc/bloc.dart';

class FavouritePlaceCubit extends Cubit<bool> {
  FavouritePlaceCubit() : super(false);

  bool _isFavourite = false;

  void favouritePlace() {
    emit(!_isFavourite);
    _isFavourite = !_isFavourite;
  }
}
