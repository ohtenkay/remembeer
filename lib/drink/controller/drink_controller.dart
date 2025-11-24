import 'package:remembeer/common/controller/controller.dart';
import 'package:remembeer/drink/model/drink.dart';
import 'package:remembeer/drink/model/drink_create.dart';
import 'package:remembeer/user_settings/service/user_settings_service.dart';

class DrinkController extends Controller<Drink, DrinkCreate> {
  final UserSettingsService userSettingsService;

  DrinkController(
    super.authService, {
    required this.userSettingsService,
  }) : super(
         collectionPath: 'drinks',
         fromJson: Drink.fromJson,
       );

  Future<void> addDefaultDrink() async {
    final userSettings = await userSettingsService.currentUserSettings;
    await createSingle(
      DrinkCreate(
        consumedAt: DateTime.now(),
        drinkType: userSettings.defaultDrinkType,
        volumeInMilliliters: userSettings.defaultDrinkSize,
      ),
    );
  }
}
