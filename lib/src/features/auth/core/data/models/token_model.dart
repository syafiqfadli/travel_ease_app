import 'package:travel_ease_app/src/features/auth/core/domain/entities/token_entity.dart';

class TokenModel extends TokenEntity {
  const TokenModel({required super.token});

  factory TokenModel.fromJson(Map<String, dynamic> parseJson) {
    return TokenModel(
      token: parseJson['authToken'] ?? '',
    );
  }
}
