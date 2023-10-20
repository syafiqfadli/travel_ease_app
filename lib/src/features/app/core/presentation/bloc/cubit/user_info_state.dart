part of 'user_info_cubit.dart';

abstract class UserInfoState extends Equatable {
  const UserInfoState();

  @override
  List<Object> get props => [];
}

class UserInfoInitial extends UserInfoState {}

class UserInfoLoading extends UserInfoState {}

class UserInfoLoaded extends UserInfoState {
  final UserEntity userEntity;

  const UserInfoLoaded({required this.userEntity});
}

class UserInfoError extends UserInfoState {
  final String message;

  const UserInfoError({required this.message});

  @override
  List<Object> get props => [message];
}
