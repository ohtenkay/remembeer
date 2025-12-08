import 'package:flutter/material.dart';
import 'package:remembeer/common/widget/animated_top_snack_bar.dart';

void _showTopSnackBar(BuildContext context, String message) {
  final overlay = Overlay.of(context);
  late OverlayEntry overlayEntry;

  overlayEntry = OverlayEntry(
    builder: (context) => AnimatedTopSnackBar(
      message: message,
      onDismissed: () => overlayEntry.remove(),
    ),
  );

  overlay.insert(overlayEntry);
}

void showDefaultDrinkAdded(BuildContext context) {
  _showTopSnackBar(context, 'Default drink added!');
}

void showDrinkDeleted(BuildContext context) {
  _showTopSnackBar(context, 'Drink deleted!');
}

void showInvitationCodeCopied(BuildContext context) {
  _showTopSnackBar(context, 'Invitation code copied to clipboard!');
}
