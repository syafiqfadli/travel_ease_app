import 'package:travel_ease_app/src/features/app/core/domain/entities/place/price_entity.dart';

class PriceModel extends PriceEntity {
  const PriceModel({required super.category, required super.price});

  factory PriceModel.fromJson(Map<String, dynamic> parseJson) {
    return PriceModel(
      category: parseJson['category'] ?? '',
      price: parseJson['price'] ?? 0,
    );
  }

  static List<PriceModel> fromList(List<dynamic> parseJson) {
    List<PriceModel> result = [];

    for (var data in parseJson) {
      result.add(PriceModel.fromJson(data));
    }

    return result;
  }
}
