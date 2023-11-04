import 'package:travel_ease_app/src/features/app/core/domain/entities/place/direction_entity.dart';

class DirectionModel extends DirectionEntity {
  const DirectionModel({required super.distance, required super.duration});

  factory DirectionModel.fromJson(Map<String, dynamic> parseJson) {
    return DirectionModel(
      distance: parseJson['distance']['value'] ?? 0,
      duration: parseJson['duration']['value'] ?? 0,
    );
  }
}
