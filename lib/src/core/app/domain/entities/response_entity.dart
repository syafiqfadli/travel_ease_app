import 'package:equatable/equatable.dart';

class ResponseEntity extends Equatable {
  final bool isSuccess;
  final dynamic data;
  final String message;

  const ResponseEntity({
    required this.isSuccess,
    required this.data,
    required this.message,
  });

  @override
  List<Object?> get props => [isSuccess, data, message];

  static get empty => const ResponseEntity(
        isSuccess: false,
        data: {},
        message: '',
      );
}
