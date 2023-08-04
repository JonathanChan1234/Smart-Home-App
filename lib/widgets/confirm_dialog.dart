import 'package:flutter/material.dart';

class ConfirmDialog extends StatelessWidget {
  const ConfirmDialog({
    super.key,
    required this.title,
    required this.content,
    this.leftBtnText = 'Cancel',
    this.rightBtnText = 'Confirm',
    required this.onLeftBtnClick,
    required this.onRightBtnClick,
  });

  final String title;
  final String content;
  final String leftBtnText;
  final String rightBtnText;
  final void Function() onLeftBtnClick;
  final void Function() onRightBtnClick;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
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
            leftBtnText,
            style: theme.textTheme.bodySmall,
          ),
        ),
        TextButton(
          onPressed: onRightBtnClick,
          child: Text(
            rightBtnText,
            style: theme.textTheme.bodySmall,
          ),
        ),
      ],
    );
  }
}
