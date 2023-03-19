import 'package:flutter/material.dart';

class RoomError extends StatelessWidget {
  const RoomError({super.key});

  @override
  Widget build(BuildContext context) {
    final colorTheme = Theme.of(context).secondaryHeaderColor;
    final textTheme = Theme.of(context).textTheme;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Something went wrong',
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
