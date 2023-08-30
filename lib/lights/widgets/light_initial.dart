import 'package:flutter/material.dart';

class LightInitial extends StatelessWidget {
  const LightInitial({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Initializing your room lighting',
            style: textTheme.headlineSmall,
          ),
        ],
      ),
    );
  }
}
