import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:travel_ease_app/src/features/auth/core/domain/entities/auth_entity.dart';
import 'package:travel_ease_app/src/features/auth/core/domain/repositories/auth_repo.dart';

part 'reset_password_state.dart';

class ResetPasswordCubit extends Cubit<ResetPasswordState> {
  final AuthRepo authRepo;

  ResetPasswordCubit({required this.authRepo}) : super(ResetPasswordInitial());

  Future<void> resetPassword(AuthEntity authEntity) async {
    emit(ResetPasswordLoading());

    final resetEither = await authRepo.resetPassword(authEntity);

    resetEither.fold(
      (failure) {
        emit(ResetPasswordError(message: failure.message));
      },
      (message) {
        emit(ResetPasswordSuccessful(message: message));
      },
    );
  }
}
