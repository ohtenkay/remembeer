import 'package:flutter/material.dart';
import 'package:remembeer/common/widget/page_template.dart';
import 'package:remembeer/drink/controller/drink_controller.dart';
import 'package:remembeer/drink/model/drink_create.dart';
import 'package:remembeer/drink/widget/drink_form.dart';
import 'package:remembeer/drink_type/model/drink_category.dart';
import 'package:remembeer/drink_type/model/drink_type.dart';
import 'package:remembeer/ioc/ioc_container.dart';

class AddDrinkPage extends StatelessWidget {
  AddDrinkPage({super.key});

  final _drinkController = get<DrinkController>();

  @override
  Widget build(BuildContext context) {
    return PageTemplate(
      title: const Text('Record a Drink'),
      child: DrinkForm(
        // TODO(metju-ac): pass user's favorite drink
        initialDrinkType: DrinkType(
          id: 'ZzQmvVon2JcCB12ZhQIZ',
          userId: 'global',
          name: 'Pilsner Urquell',
          category: DrinkCategory.Beer,
          alcoholPercentage: 4.4,
        ),
        initialConsumedAt: DateTime.now(),
        initialVolume: 500,
        onSubmit:
            ({
              required DrinkType drinkType,
              required DateTime consumedAt,
              required int volumeInMilliliters,
            }) {
              _drinkController.createSingle(
                DrinkCreate(
                  consumedAt: consumedAt,
                  drinkType: drinkType,
                  volumeInMilliliters: volumeInMilliliters,
                ),
              );
            },
      ),
    );
  }
}
