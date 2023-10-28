import 'package:travel_ease_app/src/features/app/core/data/models/place/location_model.dart';
import 'package:travel_ease_app/src/features/app/core/data/models/place/prices_model.dart';
import 'package:travel_ease_app/src/features/app/core/domain/entities/place/place_entity.dart';

class PlaceModel extends PlaceEntity {
  const PlaceModel({
    required super.placeId,
    required super.placeName,
    required super.prices,
    required super.location,
    required super.address,
    required super.phoneNo,
    required super.isFavourite,
    required super.hasMarker,
    required super.businessHours,
  });

  factory PlaceModel.fromJson(Map<String, dynamic> parseJson) {
    return PlaceModel(
      placeId: parseJson['place_id'] ?? parseJson['placeId'],
      placeName: parseJson['name'] ?? parseJson['placeName'],
      prices: parseJson['prices'] != null
          ? PriceModel.fromList(parseJson['prices'])
          : [],
      location: LocationModel.fromJson(parseJson),
      isFavourite: parseJson['isFavourite'] ?? false,
      hasMarker: parseJson['hasMarker'] ?? false,
      businessHours: parseJson['current_opening_hours'] != null
          ? businessList(parseJson['current_opening_hours']['weekday_text'])
          : [],
      address: parseJson['formatted_address'] ?? 'NO_ADDRESS',
      phoneNo: parseJson['formatted_phone_number'] ?? 'NO_PHONE',
    );
  }

  static List<PlaceModel> fromList(List<dynamic> parseJson) {
    List<PlaceModel> result = [];

    for (var data in parseJson) {
      result.add(PlaceModel.fromJson(data));
    }

    return result;
  }

  static List<String> businessList(List<dynamic> parseJson) {
    List<String> result = [];

    for (var data in parseJson) {
      result.add(data);
    }

    return result;
  }
}
