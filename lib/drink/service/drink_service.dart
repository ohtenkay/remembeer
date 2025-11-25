import 'package:remembeer/drink/controller/drink_controller.dart';
import 'package:remembeer/drink/model/drink_create.dart';
import 'package:remembeer/user_settings/service/user_settings_service.dart';

class DrinkService {
  final UserSettingsService userSettingsService;
  final DrinkController drinkController;

  DrinkService({
    required this.userSettingsService,
    required this.drinkController,
  });

  Future<void> addDefaultDrink() async {
    final userSettings = await userSettingsService.currentUserSettings;
    await drinkController.createSingle(
      DrinkCreate(
        consumedAt: DateTime.now(),
        drinkType: userSettings.defaultDrinkType,
        volumeInMilliliters: userSettings.defaultDrinkSize,
      ),
    );
  }
}
