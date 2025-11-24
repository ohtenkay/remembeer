import 'package:flutter/material.dart';

void showDefaultDrinkAdded(BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      content: Text('Default drink added!'),
      duration: Duration(seconds: 2),
    ),
  );
}
