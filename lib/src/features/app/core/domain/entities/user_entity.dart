import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String displayName;
  final String email;

  const UserEntity({required this.displayName, required this.email});

  @override
  List<Object?> get props => [displayName, email];
}
