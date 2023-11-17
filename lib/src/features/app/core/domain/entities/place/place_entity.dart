import 'package:equatable/equatable.dart';
import 'package:travel_ease_app/src/features/app/core/domain/entities/place/location_entity.dart';
import 'package:travel_ease_app/src/features/app/core/domain/entities/place/price_entity.dart';

class PlaceEntity extends Equatable {
  final String placeId;
  final String placeName;
  final List<PriceEntity> prices;
  final LocationEntity location;
  final List<String> businessHours;
  final bool isFavourite;
  final double rating;
  final String address;
  final String phoneNo;

  const PlaceEntity({
    required this.placeId,
    required this.placeName,
    required this.prices,
    required this.location,
    required this.isFavourite,
    required this.businessHours,
    required this.rating,
    required this.address,
    required this.phoneNo,
  });

  @override
  List<Object?> get props => [
        placeId,
        placeName,
        prices,
        location,
        isFavourite,
        businessHours,
        rating,
        address,
        phoneNo,
      ];

  Map<String, dynamic> toJson() {
    return {
      'placeId': placeId,
      'placeName': placeName,
      'prices': prices.map((price) => price.toJson()).toList(),
      'location': location.toJson(),
      'isFavourite': isFavourite,
      'businessHours': businessHours.map((data) => data).toList(),
      'rating': rating,
      'address': address,
      'phoneNo': phoneNo,
    };
  }
}
