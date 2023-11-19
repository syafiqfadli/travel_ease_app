import 'package:flutter/material.dart';

class ItemDetails extends StatelessWidget {
  final IconData icon;
  final Widget item;

  const ItemDetails({super.key, required this.icon, required this.item});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon),
          Flexible(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: item,
            ),
          ),
        ],
      ),
    );
  }
}
