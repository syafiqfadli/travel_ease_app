import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';
import 'package:travel_ease_app/src/features/app/core/domain/entities/place/location_entity.dart';
import 'package:travel_ease_app/src/features/app/core/domain/entities/place/place_entity.dart';

part 'attraction_state.dart';

class AttractionCubit extends Cubit<AttractionState> {
  AttractionCubit() : super(AttractionInitial());

  void getAttractions(String placeName) async {
    try {
      final directoryPath = 'assets/images/places/$placeName';

      final subDirectories = await _getSubDirectories(directoryPath);
      subDirectories.removeWhere((element) => element.contains(placeName));

      List<PlaceEntity> places = [];

      for (String path in subDirectories) {
        List<String> parts = path.split(' - ');
        String placeName = parts[0];
        String placeId = parts[1];

        final PlaceEntity place = PlaceEntity(
          placeId: placeId,
          placeName: placeName,
          prices: const [],
          location: LocationEntity.empty,
          isFavourite: false,
          businessHours: const [],
          rating: 0,
          address: '',
          phoneNo: '',
        );

        places.add(place);
      }

      emit(AttractionLoaded(places: places));
    } catch (error) {
      emit(const AttractionLoaded(places: []));
    }
  }

  Future<List<String>> _getSubDirectories(String basePath) async {
    try {
      final assetManifestContent =
          await rootBundle.loadString('AssetManifest.json');
      final Map<String, dynamic> assetManifest =
          json.decode(assetManifestContent);

      final subDirectories = assetManifest.keys
          .where((String key) => key.startsWith(basePath))
          .where((String key) => key.contains('/') && !key.endsWith('/'))
          .map((String key) {
            final List<String> parts = key.split('/');
            return parts[parts.length - 2];
          })
          .toSet()
          .toList();

      return subDirectories;
    } catch (error) {
      throw Error();
    }
  }
}
