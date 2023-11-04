import 'package:equatable/equatable.dart';

class DirectionEntity extends Equatable {
  final int distance;
  final int duration;

  const DirectionEntity({required this.distance, required this.duration});

  @override
  List<Object?> get props => [distance, duration];

  static get empty => const DirectionEntity(
        distance: 0,
        duration: 0,
      );
}
