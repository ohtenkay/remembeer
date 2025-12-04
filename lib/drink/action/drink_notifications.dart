import 'package:flutter/material.dart';

void _showTopSnackBar(BuildContext context, String message) {
  final overlay = Overlay.of(context);
  late OverlayEntry overlayEntry;

  overlayEntry = OverlayEntry(
    builder: (context) => Positioned(
      top: MediaQuery.of(context).padding.top + 8,
      left: 16,
      right: 16,
      child: Material(
        elevation: 6,
        borderRadius: BorderRadius.circular(8),
        color: Theme.of(context).colorScheme.inverseSurface,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Text(
            message,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onInverseSurface,
            ),
          ),
        ),
      ),
    ),
  );

  overlay.insert(overlayEntry);

  Future.delayed(const Duration(seconds: 2), () {
    overlayEntry.remove();
  });
}

void showDefaultDrinkAdded(BuildContext context) {
  _showTopSnackBar(context, 'Default drink added!');
}

void showDrinkDeleted(BuildContext context) {
  _showTopSnackBar(context, 'Drink deleted!');
}
