import 'package:flutter/material.dart';
import 'package:remembeer/common/widget/async_builder.dart';
import 'package:remembeer/drink_type/controller/drink_type_controller.dart';
import 'package:remembeer/drink_type/model/drink_type.dart';
import 'package:remembeer/ioc/ioc_container.dart';

class DrinkTypeDropdown extends StatelessWidget {
  final DrinkType? selectedDrinkType;
  final void Function(DrinkType?) onChanged;

  DrinkTypeDropdown({
    super.key,
    required this.selectedDrinkType,
    required this.onChanged,
  });

  final _drinkTypeController = get<DrinkTypeController>();

  @override
  Widget build(BuildContext context) {
    return AsyncBuilder(
      stream: _drinkTypeController.allAvailableDrinkTypesStream,
      builder: (context, unmodifiableDrinkTypes) {
        final drinkTypes = unmodifiableDrinkTypes.toList();
        if (selectedDrinkType != null &&
            !drinkTypes.contains(selectedDrinkType)) {
          drinkTypes.insert(0, selectedDrinkType!);
        }

        // TODO(metju-ac): use better UI component
        return DropdownButtonFormField<DrinkType>(
          initialValue: selectedDrinkType,
          hint: const Text('Select a drink'),
          items: drinkTypes.map((drinkType) {
            return DropdownMenuItem(
              value: drinkType,
              child: Text(drinkType.name),
            );
          }).toList(),
          onChanged: onChanged,
          validator: (value) {
            if (value == null) {
              return 'Please select your drink.';
            }
            return null;
          },
          decoration: const InputDecoration(
            labelText: 'Drink',
            border: OutlineInputBorder(),
          ),
        );
      },
    );
  }
}
