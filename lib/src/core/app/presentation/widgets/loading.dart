import 'package:flutter/material.dart';
import 'package:travel_ease_app/src/core/utils/constants.dart';

class CustomLoading extends StatelessWidget {
  const CustomLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        color: PrimaryColor.navyBlack,
      ),
    );
  }
}
