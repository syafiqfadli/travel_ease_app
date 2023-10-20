import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:travel_ease_app/src/features/auth/core/domain/entities/auth_entity.dart';
import 'package:travel_ease_app/src/features/auth/core/domain/repositories/auth_repo.dart';
import 'package:travel_ease_app/src/features/auth/features/login/presentation/bloc/token_cubit.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final AuthRepo authRepo;
  final TokenCubit tokenCubit;

  LoginCubit({
    required this.authRepo,
    required this.tokenCubit,
  }) : super(LoginInitial());

  Future<void> logIn(AuthEntity authEntity) async {
    emit(LoginLoading());

    final loginEither = await authRepo.logIn(authEntity);

    loginEither.fold(
      (failure) {
        emit(LoginError(message: failure.message));
        tokenCubit.getToken(null);
      },
      (token) {
        emit(LoginSuccessful());
        tokenCubit.getToken(token.token);
      },
    );
  }
}
