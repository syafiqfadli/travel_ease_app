import 'package:equatable/equatable.dart';

class AuthEntity extends Equatable {
  final String email;
  final String password;
  final String? displayName;

  const AuthEntity({
    required this.email,
    required this.password,
    this.displayName,
  });

  @override
  List<Object?> get props => [email, password, displayName];
}
