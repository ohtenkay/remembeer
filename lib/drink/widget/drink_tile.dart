import 'package:flutter/material.dart';
import 'package:remembeer/common/beer_icon.dart';
import 'package:remembeer/drink/model/drink.dart';
import 'package:remembeer/drink/widget/update_drink_page.dart';

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
        'Drank on ${drink.consumedAt.toLocal()} on ${drink.location?.latitude} ${drink.location?.longitude} ${drink.deletedAt}',
      ),
      trailing: IconButton(
        onPressed: () => {
          Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (context) => UpdateDrinkPage(drinkToUpdate: drink),
            ),
          ),
        },
        icon: Icon(Icons.chevron_right),
      ),
    );
  }
}
