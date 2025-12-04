import 'package:flutter/cupertino.dart';
import 'package:remembeer/common/widget/page_template.dart';
import 'package:remembeer/drink/controller/drink_controller.dart';
import 'package:remembeer/drink/model/drink.dart';
import 'package:remembeer/drink/widget/drink_form.dart';
import 'package:remembeer/ioc/ioc_container.dart';

class UpdateDrinkPage extends StatelessWidget {
  final Drink drinkToUpdate;

  UpdateDrinkPage({super.key, required this.drinkToUpdate});

  final _drinkController = get<DrinkController>();

  @override
  Widget build(BuildContext context) {
    return PageTemplate(
      title: const Text('Update Drink'),
      child: DrinkForm(
        initialDrinkType: drinkToUpdate.drinkType,
        initialConsumedAt: drinkToUpdate.consumedAt,
        initialVolume: drinkToUpdate.volumeInMilliliters,
        onSubmit:
            (
              drinkType,
              consumedAt,
              volumeInMilliliters,
            ) async {
              await _drinkController.updateSingle(
                drinkToUpdate.copyWith(
                  consumedAt: consumedAt,
                  drinkType: drinkType,
                  volumeInMilliliters: volumeInMilliliters,
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
