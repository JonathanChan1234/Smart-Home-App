import 'package:flutter/material.dart';

class ErrorView extends StatelessWidget {
  const ErrorView({
    super.key,
    this.message,
    this.retryCallback,
  });

  final String? message;
  final void Function()? retryCallback;

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
          ),
          if (retryCallback != null)
            ElevatedButton(onPressed: retryCallback, child: const Text('Retry'))
        ],
      ),
    );
  }
}
