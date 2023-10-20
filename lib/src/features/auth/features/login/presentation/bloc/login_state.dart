part of 'login_cubit.dart';

abstract class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object> get props => [];
}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginSuccessful extends LoginState {}

class LoginError extends LoginState {
  final String message;

  const LoginError({required this.message});

  @override
  List<Object> get props => [message];
}
