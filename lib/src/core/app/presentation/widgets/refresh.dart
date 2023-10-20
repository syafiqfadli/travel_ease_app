import 'package:flutter/material.dart';
import 'package:travel_ease_app/src/core/utils/constants.dart';

class CustomRefresh extends StatelessWidget {
  final Future<void> Function() onRefresh;
  final Widget child;

  const CustomRefresh({
    Key? key,
    required this.onRefresh,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      backgroundColor: PrimaryColor.navyBlack,
      color: PrimaryColor.pureWhite,
      displacement: 1,
      onRefresh: onRefresh,
      child: child,
    );
  }
}
