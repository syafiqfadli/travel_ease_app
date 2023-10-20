import 'package:travel_ease_app/src/features/app/core/domain/entities/place/location_entity.dart';

class LocationModel extends LocationEntity {
  const LocationModel({required super.longitude, required super.latitude});

  factory LocationModel.fromJson(Map<String, dynamic> parseJson) {
    return LocationModel(
      longitude: parseJson['geometry']['location']['lng'] ??
          parseJson['location']['longitude'],
      latitude: parseJson['geometry']['location']['lat'] ??
          parseJson['location']['latitude'],
    );
  }
}
