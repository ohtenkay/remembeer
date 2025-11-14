import 'package:flutter/material.dart';
import 'package:remembeer/common/widget/drink_icon.dart';
import 'package:remembeer/drink_type/model/drink_type.dart';
import 'package:remembeer/drink_type/widget/update_drink_type_page.dart';

class DrinkTypeTile extends StatelessWidget {
  final DrinkType drinkType;

  const DrinkTypeTile({super.key, required this.drinkType});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: DrinkIcon(category: drinkType.category),
      title: Text(drinkType.name),
      subtitle: Text('ABV: ${drinkType.alcoholPercentage}%'),
      trailing: IconButton(
        onPressed: () => {
          Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (context) =>
                  UpdateDrinkTypePage(drinkTypeToUpdate: drinkType),
            ),
          ),
        },
        icon: Icon(Icons.chevron_right),
      ),
    );
  }
}
