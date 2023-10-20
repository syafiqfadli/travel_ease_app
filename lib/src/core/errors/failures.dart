import 'package:equatable/equatable.dart';

abstract class Failure<T> extends Equatable {
  final String message;

  const Failure._({required this.message});

  @override
  List<Object> get props => [message];
}

class ServerFailure<T> extends Failure<T> {
  const ServerFailure({String message = ''}) : super._(message: message);

  @override
  List<Object> get props => [message];
}

class SystemFailure<T> extends Failure {
  const SystemFailure({String message = ''}) : super._(message: message);

  @override
  List<Object> get props => [message];
}
