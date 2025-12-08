import 'package:flutter/material.dart';

Future<void> showConfirmationDialog({
  required BuildContext context,
  required String title,
  required String text,
  required Future<void> Function() onPressed,
  required String submitButtonText,
  bool isDestructive = false,
}) {
  return showDialog<void>(
    context: context,
    builder: (context) {
      final theme = Theme.of(context);

      return AlertDialog(
        title: Text(title),
        content: Text(text),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await onPressed();
            },
            style: isDestructive
                ? FilledButton.styleFrom(
                    backgroundColor: theme.colorScheme.error,
                  )
                : null,
            child: Text(submitButtonText),
          ),
        ],
      );
    },
  );
}
