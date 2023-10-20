import 'package:travel_ease_app/src/core/app/domain/entities/response_entity.dart';

class ResponseModel extends ResponseEntity {
  const ResponseModel({
    required bool isSuccess,
    required data,
    required String message,
  }) : super(
          isSuccess: isSuccess,
          data: data,
          message: message,
        );

  factory ResponseModel.fromJson(Map<String, dynamic> parseJson) {
    return ResponseModel(
      isSuccess: parseJson['isSuccess'] ?? false,
      data: parseJson['data'] ?? {},
      message: parseJson['message'] ?? '',
    );
  }
}
