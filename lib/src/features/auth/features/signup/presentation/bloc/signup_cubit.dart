import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:travel_ease_app/src/features/auth/core/domain/entities/auth_entity.dart';
import 'package:travel_ease_app/src/features/auth/core/domain/repositories/auth_repo.dart';

part 'signup_state.dart';

class SignUpCubit extends Cubit<SignUpState> {
  final AuthRepo authRepo;

  SignUpCubit({
    required this.authRepo,
  }) : super(SignUpInitial());

  Future<void> signUp(AuthEntity authEntity) async {
    emit(SignUpLoading());

    final signUpEither = await authRepo.signUp(authEntity);

    signUpEither.fold(
      (failure) {
        emit(SignUpError(message: failure.message));
      },
      (message) {
        emit(SignUpSuccessful(message: message));
      },
    );
  }
}
