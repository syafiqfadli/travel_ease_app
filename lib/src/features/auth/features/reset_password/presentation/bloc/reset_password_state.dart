part of 'reset_password_cubit.dart';

sealed class ResetPasswordState extends Equatable {
  const ResetPasswordState();

  @override
  List<Object> get props => [];
}

final class ResetPasswordInitial extends ResetPasswordState {}

class ResetPasswordLoading extends ResetPasswordState {}

class ResetPasswordSuccessful extends ResetPasswordState {
  final String message;

  const ResetPasswordSuccessful({required this.message});

  @override
  List<Object> get props => [message];
}

class ResetPasswordError extends ResetPasswordState {
  final String message;

  const ResetPasswordError({required this.message});

  @override
  List<Object> get props => [message];
}
