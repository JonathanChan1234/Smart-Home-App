import 'package:flutter/material.dart';

class DevicesInitial extends StatelessWidget {
  const DevicesInitial({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Initializing Devices',
            style: textTheme.headlineSmall,
          )
        ],
      ),
    );
  }
}
