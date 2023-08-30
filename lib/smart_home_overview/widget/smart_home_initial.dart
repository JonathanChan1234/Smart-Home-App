import 'package:flutter/material.dart';

class SmartHomeInitial extends StatelessWidget {
  const SmartHomeInitial({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Initializing',
            style: textTheme.headlineSmall,
          ),
        ],
      ),
    );
  }
}
