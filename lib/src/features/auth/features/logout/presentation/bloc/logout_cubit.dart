import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:travel_ease_app/src/features/auth/core/domain/repositories/auth_repo.dart';
import 'package:travel_ease_app/src/features/auth/features/login/presentation/bloc/token_cubit.dart';

part 'logout_state.dart';

class LogoutCubit extends Cubit<LogoutState> {
  final AuthRepo authRepo;
  final TokenCubit tokenCubit;

  LogoutCubit({
    required this.authRepo,
    required this.tokenCubit,
  }) : super(LogoutInitial());

  Future<void> logout() async {
    await authRepo.logout();
    tokenCubit.setToken(null);
  }
}
