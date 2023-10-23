import 'package:equatable/equatable.dart';

class PriceEntity extends Equatable {
  final String category;
  final double price;

  const PriceEntity({required this.category, required this.price});

  @override
  List<Object?> get props => [category, price];

  Map<String, dynamic> toJson() {
    return {
      'category': category,
      'price': price,
    };
  }
}
