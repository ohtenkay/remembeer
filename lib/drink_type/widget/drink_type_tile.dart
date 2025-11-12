import 'package:flutter/material.dart';
import 'package:remembeer/common/beer_icon.dart';
import 'package:remembeer/drink_type/model/drink_type.dart';

class DrinkTypeTile extends StatelessWidget {
  final DrinkType drinkType;

  const DrinkTypeTile({super.key, required this.drinkType});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const BeerIcon(),
      title: Text(drinkType.name),
      subtitle: Text('ABV: ${drinkType.alcoholPercentage}%'),
      trailing: IconButton(
        onPressed: () => {},
        icon: Icon(Icons.chevron_right),
      ),
    );
  }
}
