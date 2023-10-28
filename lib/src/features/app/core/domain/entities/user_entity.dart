import 'package:equatable/equatable.dart';
import 'package:travel_ease_app/src/features/app/core/domain/entities/place/place_entity.dart';

class UserEntity extends Equatable {
  final String displayName;
  final String email;
  final List<PlaceEntity> favouritePlaces;

  const UserEntity({
    required this.displayName,
    required this.email,
    required this.favouritePlaces,
  });

  @override
  List<Object?> get props => [displayName, email, favouritePlaces];
}
