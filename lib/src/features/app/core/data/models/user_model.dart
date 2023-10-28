import 'package:travel_ease_app/src/features/app/core/data/models/place/place_model.dart';
import 'package:travel_ease_app/src/features/app/core/domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.displayName,
    required super.email,
    required super.favouritePlaces,
  });

  factory UserModel.fromJson(Map<String, dynamic> parseJson) {
    return UserModel(
      displayName: parseJson['displayName'] ?? '',
      email: parseJson['email'] ?? '',
      favouritePlaces: parseJson['favouritePlaces'] != null
          ? PlaceModel.fromList(parseJson['favouritePlaces'])
          : [],
    );
  }
}
