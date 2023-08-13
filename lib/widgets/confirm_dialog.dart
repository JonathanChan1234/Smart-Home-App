import 'package:flutter/material.dart';
import 'package:smart_home/l10n/l10n.dart';

class ConfirmDialog extends StatelessWidget {
  const ConfirmDialog({
    super.key,
    required this.title,
    required this.content,
    this.leftBtnText,
    this.rightBtnText,
    required this.onLeftBtnClick,
    required this.onRightBtnClick,
  });

  final String title;
  final String content;
  final String? leftBtnText;
  final String? rightBtnText;
  final void Function() onLeftBtnClick;
  final void Function() onRightBtnClick;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final localizations = AppLocalizations.of(context);
    return AlertDialog(
      title: Text(title),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            Text(content),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: onLeftBtnClick,
          child: Text(
            leftBtnText ?? localizations.cancel,
            style: theme.textTheme.bodySmall,
          ),
        ),
        TextButton(
          onPressed: onRightBtnClick,
          child: Text(
            rightBtnText ?? localizations.delete,
            style: theme.textTheme.bodySmall,
          ),
        ),
      ],
    );
  }
}
