import 'package:equatable/equatable.dart';
import 'package:travel_ease_app/src/features/app/core/domain/entities/place/location_entity.dart';
import 'package:travel_ease_app/src/features/app/core/domain/entities/place/price_entity.dart';

class PlaceEntity extends Equatable {
  final String placeId;
  final String placeName;
  final List<PriceEntity> prices;
  final LocationEntity location;

  const PlaceEntity({
    required this.placeId,
    required this.placeName,
    required this.prices,
    required this.location,
  });

  @override
  List<Object?> get props => [placeId, placeName, prices, location];
}
