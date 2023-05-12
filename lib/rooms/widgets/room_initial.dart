import 'package:flutter/material.dart';

class RoomInitial extends StatelessWidget {
  const RoomInitial({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Initializing Room',
            style: textTheme.headlineSmall,
          )
        ],
      ),
    );
  }
}
