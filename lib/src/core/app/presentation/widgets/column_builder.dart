import 'package:flutter/material.dart';

class ColumnBuilder extends StatelessWidget {
  final int itemCount;
  final IndexedWidgetBuilder itemBuilder;
  final MainAxisAlignment mainAxisAlignment;
  final MainAxisSize mainAxisSize;
  final CrossAxisAlignment crossAxisAlignment;
  final TextDirection textDirection;
  final VerticalDirection verticalDirection;

  const ColumnBuilder({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.mainAxisSize = MainAxisSize.max,
    this.crossAxisAlignment = CrossAxisAlignment.start,
    this.textDirection = TextDirection.ltr,
    this.verticalDirection = VerticalDirection.down,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(
        itemCount,
        (index) => itemBuilder(context, index),
      ).toList(),
    );
  }
}
