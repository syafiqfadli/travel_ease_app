import 'package:equatable/equatable.dart';

class LocationEntity extends Equatable {
  final double longitude;
  final double latitude;

  const LocationEntity({required this.longitude, required this.latitude});

  @override
  List<Object?> get props => [longitude, latitude];

  Map<String, dynamic> toJson() {
    return {
      'longitude': longitude,
      'latitude': latitude,
    };
  }

  static get empty => const LocationEntity(
        longitude: 0,
        latitude: 0,
      );
}
