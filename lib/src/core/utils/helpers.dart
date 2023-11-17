import 'package:travel_ease_app/src/features/app/core/domain/entities/place/place_entity.dart';

class TimeHelper {
  static String convertSecondsToTime(int seconds) {
    if (seconds < 60) {
      return "$seconds sec${seconds != 1 ? 's' : ''}";
    } else if (seconds < 3600) {
      final minutes = seconds ~/ 60;

      return "$minutes min${minutes != 1 ? 's' : ''}";
    } else if (seconds < 86400) {
      final hours = seconds ~/ 3600;
      final remainingMinutes = (seconds % 3600) ~/ 60;

      return "$hours hour${hours != 1 ? 's' : ''} ${remainingMinutes > 0 ? '$remainingMinutes min${remainingMinutes != 1 ? 's' : ''}' : ''}";
    } else {
      final days = seconds ~/ 86400;

      return "$days day${days != 1 ? 's' : ''}";
    }
  }
}

class StringHelper {
  static String capitalizeFirstLetter(String input) {
    if (input.isEmpty) {
      return input;
    }

    return input[0].toUpperCase() + input.substring(1).toLowerCase();
  }

  static String setPlaceDirection(List<PlaceEntity> places) {
    if (places.isEmpty) {
      return '';
    }

    String result = places
        .map((place) => place.placeName)
        .reduce((value, element) => '$value -> $element');

    return result;
  }
}
