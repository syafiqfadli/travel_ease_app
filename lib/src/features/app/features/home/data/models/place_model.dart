import 'package:travel_ease_app/src/features/app/core/data/models/place/location_model.dart';
import 'package:travel_ease_app/src/features/app/core/data/models/place/prices_model.dart';
import 'package:travel_ease_app/src/features/app/core/domain/entities/place/place_entity.dart';

class PlaceModel extends PlaceEntity {
  const PlaceModel({
    required super.placeId,
    required super.placeName,
    required super.prices,
    required super.location,
  });

  factory PlaceModel.fromJson(Map<String, dynamic> parseJson) {
    return PlaceModel(
      placeId: parseJson['place_id'] ?? parseJson['placeId'],
      placeName: parseJson['name'] ?? parseJson['placeName'],
      prices: PriceModel.fromList(parseJson['prices'] ?? []),
      location: LocationModel.fromJson(parseJson),
    );
  }

  static List<PlaceModel> fromList(List<dynamic> parseJson) {
    List<PlaceModel> result = [];

    for (var data in parseJson) {
      result.add(PlaceModel.fromJson(data));
    }

    return result;
  }
}
