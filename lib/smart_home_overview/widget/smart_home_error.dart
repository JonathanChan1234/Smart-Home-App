import 'package:flutter/material.dart';

class SmartHomeError extends StatelessWidget {
  const SmartHomeError({super.key, this.message});

  final String? message;

  @override
  Widget build(BuildContext context) {
    final colorTheme = Theme.of(context).secondaryHeaderColor;
    final textTheme = Theme.of(context).textTheme;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            message ?? 'Something went wrong',
            style: textTheme.headlineSmall?.copyWith(color: colorTheme),
          ),
          const Padding(
            padding: EdgeInsets.all(16),
            child: CircularProgressIndicator(),
          ),
        ],
      ),
    );
  }
}
