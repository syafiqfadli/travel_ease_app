import 'package:flutter/material.dart';
import 'package:travel_ease_app/src/core/app/presentation/widgets/loading.dart';

class LoadingResult extends StatelessWidget {
  final String status;

  const LoadingResult({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const CustomLoading(),
        const SizedBox(height: 20),
        Text(status),
      ],
    );
  }
}
