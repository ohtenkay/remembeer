import 'package:flutter/material.dart';
import 'package:remembeer/common/beer_icon.dart';
import 'package:remembeer/drink/model/drink.dart';

class DrinkTile extends StatelessWidget {
  final Drink drink;

  const DrinkTile({super.key, required this.drink});

  @override
  Widget build(BuildContext context) {
    // TODO(metju-ac): Implement a proper drink tile, this is just a placeholder.
    return ListTile(
      leading: BeerIcon(),
      title: Text('Drink named ${drink.drinkType.name}'),
      subtitle: Text(
        'Drank on ${drink.timestamp.toLocal()} on ${drink.location?.latitude} ${drink.location?.longitude}',
      ),
      trailing: Icon(Icons.chevron_right),
    );
  }
}
