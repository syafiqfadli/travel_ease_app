part of 'set_page_cubit.dart';

abstract class SetPageState extends Equatable {
  const SetPageState();

  @override
  List<Object> get props => [];
}

class SelectedPage extends SetPageState {
  final String title;
  final int index;

  const SelectedPage({required this.title, required this.index});

  @override
  List<Object> get props => [title, index];
}
