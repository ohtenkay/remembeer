import 'package:flutter/cupertino.dart';
import 'package:remembeer/common/widget/page_template.dart';
import 'package:remembeer/drink/model/drink.dart';
import 'package:remembeer/drink/service/drink_service.dart';
import 'package:remembeer/drink/widget/drink_form.dart';
import 'package:remembeer/ioc/ioc_container.dart';

class UpdateDrinkPage extends StatelessWidget {
  final Drink drinkToUpdate;

  UpdateDrinkPage({super.key, required this.drinkToUpdate});

  final _drinkService = get<DrinkService>();

  @override
  Widget build(BuildContext context) {
    return PageTemplate(
      title: const Text('Update Drink'),
      child: DrinkForm(
        initialDrinkType: drinkToUpdate.drinkType,
        initialConsumedAt: drinkToUpdate.consumedAt,
        initialVolume: drinkToUpdate.volumeInMilliliters,
        initialLocation: drinkToUpdate.location,
        onSubmit: (drinkType, consumedAt, volumeInMilliliters, location) async {
          await _drinkService.updateDrink(
            oldDrink: drinkToUpdate,
            newDrink: drinkToUpdate.copyWith(
              consumedAt: consumedAt,
              drinkType: drinkType,
              volumeInMilliliters: volumeInMilliliters,
              location: location,
            ),
          );
          if (context.mounted) {
            Navigator.of(context).pop();
          }
        },
      ),
    );
  }
}
