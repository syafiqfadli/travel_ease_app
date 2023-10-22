import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:travel_ease_app/src/features/auth/core/domain/repositories/auth_repo.dart';

part 'logout_state.dart';

class LogoutCubit extends Cubit<LogoutState> {
  final AuthRepo authRepo;

  LogoutCubit({required this.authRepo}) : super(LogoutInitial());

  Future<void> logout() async {
    await authRepo.logout();
  }
}
