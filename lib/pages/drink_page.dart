import 'package:flutter/material.dart';
import 'package:remembeer/drink/widget/drink_list.dart';

class DrinkPage extends StatelessWidget {
  const DrinkPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Date Selector Placeholder',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        DrinkList(),
      ],
    );
  }
}
