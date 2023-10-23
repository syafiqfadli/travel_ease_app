import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:travel_ease_app/src/features/app/core/domain/entities/user_entity.dart';
import 'package:travel_ease_app/src/features/app/core/domain/repositories/app_repo.dart';
import 'package:travel_ease_app/src/features/auth/features/login/presentation/bloc/token_cubit.dart';

part 'user_info_state.dart';

class UserInfoCubit extends Cubit<UserInfoState> {
  final AppRepo appRepo;
  final TokenCubit tokenCubit;

  UserInfoCubit({
    required this.appRepo,
    required this.tokenCubit,
  }) : super(UserInfoInitial());

  Future<void> getUser() async {
    emit(UserInfoLoading());

    final userEither = await appRepo.userInfo(tokenCubit.state!);

    userEither.fold(
      (failure) => emit(UserInfoError(message: failure.message)),
      (user) => emit(UserInfoLoaded(userEntity: user)),
    );
  }
}
