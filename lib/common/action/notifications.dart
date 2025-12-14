import 'package:flutter/material.dart';
import 'package:remembeer/common/widget/animated_top_snack_bar.dart';

void showNotification(BuildContext context, String message) {
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
