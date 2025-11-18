import 'package:flutter/material.dart';
import 'package:remembeer/common/widget/async_builder.dart';
import 'package:remembeer/common/widget/page_template.dart';
import 'package:remembeer/drink/controller/drink_controller.dart';
import 'package:remembeer/drink/model/drink.dart';
import 'package:remembeer/drink/model/drink_create.dart';
import 'package:remembeer/drink/widget/drink_form.dart';
import 'package:remembeer/drink_type/model/drink_type.dart';
import 'package:remembeer/ioc/ioc_container.dart';
import 'package:remembeer/user_data/service/user_data_service.dart';

class DrinkFormPage extends StatelessWidget {
  final Drink? drinkToUpdate;

  DrinkFormPage({super.key, this.drinkToUpdate});

  final _drinkController = get<DrinkController>();
  final _userDataService = get<UserDataService>();

  @override
  Widget build(BuildContext context) {
    final isUpdate = drinkToUpdate != null;

    if (isUpdate) {
      return _buildPage(
        context: context,
        drinkType: drinkToUpdate!.drinkType,
        consumedAt: drinkToUpdate!.consumedAt,
        volume: drinkToUpdate!.volumeInMilliliters,
        isUpdate: true,
      );
    }

    return AsyncBuilder(
      future: _userDataService.getCurrentUserData,
      builder: (context, userData) {
        return _buildPage(
          context: context,
          drinkType: userData.defaultDrinkType,
          consumedAt: DateTime.now(),
          volume: userData.defaultDrinkSize,
          isUpdate: false,
        );
      },
    );
  }

  PageTemplate _buildPage({
    required BuildContext context,
    required DrinkType drinkType,
    required DateTime consumedAt,
    required int volume,
    required bool isUpdate,
  }) {
    return PageTemplate(
      title: Text(isUpdate ? 'Update Drink' : 'Record a Drink'),
      child: DrinkForm(
        initialDrinkType: drinkType,
        initialConsumedAt: consumedAt,
        initialVolume: volume,
        onSubmit:
            (
              drinkType,
              consumedAt,
              volumeInMilliliters,
            ) async {
              if (isUpdate) {
                await _drinkController.updateSingle(
                  drinkToUpdate!.copyWith(
                    consumedAt: consumedAt,
                    drinkType: drinkType,
                    volumeInMilliliters: volumeInMilliliters,
                  ),
                );
              } else {
                await _drinkController.createSingle(
                  DrinkCreate(
                    consumedAt: consumedAt,
                    drinkType: drinkType,
                    volumeInMilliliters: volumeInMilliliters,
                  ),
                );
              }
              if (context.mounted) {
                Navigator.of(context).pop();
              }
            },
        onDelete: isUpdate
            ? () async {
                await _drinkController.deleteSingle(drinkToUpdate!);
                if (context.mounted) {
                  Navigator.of(context).pop();
                }
              }
            : null,
      ),
    );
  }
}
