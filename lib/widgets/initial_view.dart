import 'package:flutter/material.dart';

class InitialView extends StatelessWidget {
  const InitialView({super.key, this.title});

  final String? title;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title ?? 'Initializing',
            style: textTheme.headlineSmall,
          )
        ],
      ),
    );
  }
}
