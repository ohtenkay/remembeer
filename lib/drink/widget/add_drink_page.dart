import 'package:flutter/material.dart';
import 'package:remembeer/common/widget/async_builder.dart';
import 'package:remembeer/common/widget/page_template.dart';
import 'package:remembeer/drink/controller/drink_controller.dart';
import 'package:remembeer/drink/model/drink_create.dart';
import 'package:remembeer/drink/widget/drink_form.dart';
import 'package:remembeer/ioc/ioc_container.dart';
import 'package:remembeer/user_data/service/user_data_service.dart';

class AddDrinkPage extends StatelessWidget {
  AddDrinkPage({super.key});

  final _drinkController = get<DrinkController>();
  final _userDataService = get<UserDataService>();

  @override
  Widget build(BuildContext context) {
    return AsyncBuilder(
      future: _userDataService.getCurrentUserData,
      builder: (context, userData) {
        return PageTemplate(
          title: const Text('Record a Drink'),
          child: DrinkForm(
            initialDrinkType: userData.defaultDrinkType,
            initialConsumedAt: DateTime.now(),
            initialVolume: userData.defaultDrinkSize,
            onSubmit:
                (
                  drinkType,
                  consumedAt,
                  volumeInMilliliters,
                ) async {
                  await _drinkController.createSingle(
                    DrinkCreate(
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
      },
    );
  }
}
