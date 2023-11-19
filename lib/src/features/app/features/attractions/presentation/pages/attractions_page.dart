import 'package:flutter/widgets.dart';
import 'package:travel_ease_app/src/features/app/features/attractions/presentation/widgets/attraction_card.dart';

class AttractionsPage extends StatefulWidget {
  const AttractionsPage({super.key});

  @override
  State<AttractionsPage> createState() => _AttractionsPageState();
}

class _AttractionsPageState extends State<AttractionsPage> {
  final List<Map<String, dynamic>> places = [
    {
      "placeName": 'Ayer Keroh',
      "image": 'ayer-keroh.png',
    },
    {
      "placeName": 'Banda Hilir',
      "image": 'banda-hilir.png',
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
        image: '${places[index]['image']}',
      ),
    );
  }
}
