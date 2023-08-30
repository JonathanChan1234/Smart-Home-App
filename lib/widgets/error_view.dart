import 'package:flutter/material.dart';
import 'package:smart_home/l10n/l10n.dart';

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
    final localizations = AppLocalizations.of(context);
    final textTheme = Theme.of(context).textTheme;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('🙈', style: TextStyle(fontSize: 64)),
          Text(
            message ?? localizations.somethingWentWrong,
            style: textTheme.headlineSmall?.copyWith(color: Colors.red),
          ),
          if (retryCallback != null)
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.red,
              ),
              icon: const Icon(Icons.refresh),
              onPressed: retryCallback,
              label: Text(localizations.retry),
            ),
        ]
            .map(
              (widget) => Padding(
                padding: const EdgeInsets.all(16),
                child: widget,
              ),
            )
            .toList(),
      ),
    );
  }
}
