import 'package:flutter/material.dart';

class SmartHomeLoading extends StatelessWidget {
  const SmartHomeLoading({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Loading...', style: textTheme.headlineSmall),
          const Padding(
            padding: EdgeInsets.all(16),
            child: CircularProgressIndicator(),
          ),
        ],
      ),
    );
  }
}
