import 'package:flutter/material.dart';
import 'package:remembeer/common/widget/page_template.dart';
import 'package:remembeer/drink_type/model/drink_type.dart';
import 'package:remembeer/drink_type/model/drink_type_controller.dart';
import 'package:remembeer/drink_type/widget/drink_type_form.dart';
import 'package:remembeer/ioc/ioc_container.dart';

class UpdateDrinkTypePage extends StatelessWidget {
  final DrinkType drinkTypeToUpdate;

  UpdateDrinkTypePage({super.key, required this.drinkTypeToUpdate});

  final _drinkTypeController = get<DrinkTypeController>();

  @override
  Widget build(BuildContext context) {
    return PageTemplate(
      title: const Text('Update Custom Drink Type'),
      child: DrinkTypeForm(
        initialName: drinkTypeToUpdate.name,
        initialAlcoholPercentage: drinkTypeToUpdate.alcoholPercentage,
        onSubmit: (name, alcoholPercentage) {
          _drinkTypeController.updateSingle(
            drinkTypeToUpdate.copyWith(
              name: name,
              alcoholPercentage: alcoholPercentage,
            ),
          );
        },
      ),
    );
  }
}
