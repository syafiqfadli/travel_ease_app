import 'package:flutter/widgets.dart';
import 'package:travel_ease_app/src/features/app/core/domain/entities/place/location_entity.dart';
import 'package:travel_ease_app/src/features/app/features/attractions/presentation/widgets/attraction_card.dart';

class AtractionsPage extends StatefulWidget {
  const AtractionsPage({super.key});

  @override
  State<AtractionsPage> createState() => _AtractionsPageState();
}

class _AtractionsPageState extends State<AtractionsPage> {
  final List<Map<String, dynamic>> places = [
    {
      "placeName": 'Ayer Keroh',
      "image": 'ayer-keroh.jpeg',
      "location": const LocationEntity(
        longitude: 102.2945,
        latitude: 2.2699,
      )
    },
    {
      "placeName": 'Banda Hilir',
      "image": 'banda-hilir.jpeg',
      "location": const LocationEntity(
        longitude: 102.2505,
        latitude: 2.1926,
      )
    },
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      physics: const BouncingScrollPhysics(
        parent: AlwaysScrollableScrollPhysics(),
      ),
      itemCount: places.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisExtent: 300,
      ),
      itemBuilder: (context, index) => AttractionCard(
        placeName: places[index]['placeName'],
        location: places[index]['location'],
        image: places[index]['image'],
      ),
    );
  }
}
