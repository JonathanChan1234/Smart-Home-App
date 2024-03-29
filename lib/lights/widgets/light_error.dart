import 'package:flutter/material.dart';

class LightError extends StatelessWidget {
  const LightError({super.key, this.message});

  final String? message;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('🙈', style: TextStyle(fontSize: 64)),
          Text(
            message ?? 'Something went wrong',
            style: textTheme.headlineSmall?.copyWith(color: Colors.red),
          ),
          const Padding(
            padding: EdgeInsets.all(16),
          )
        ],
      ),
    );
  }
}
