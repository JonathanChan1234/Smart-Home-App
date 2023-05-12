import 'package:flutter/material.dart';

class DevicesLoading extends StatelessWidget {
  const DevicesLoading({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Fetching Your Devices...', style: textTheme.headlineSmall),
          const Padding(
            padding: EdgeInsets.all(16),
            child: CircularProgressIndicator(),
          )
        ],
      ),
    );
  }
}
