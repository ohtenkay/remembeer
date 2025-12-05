import 'package:remembeer/drink/controller/drink_controller.dart';
import 'package:remembeer/drink/model/drink.dart';
import 'package:remembeer/drink/model/drink_create.dart';
import 'package:remembeer/drink/service/date_service.dart';
import 'package:remembeer/user_settings/controller/user_settings_controller.dart';
import 'package:rxdart/rxdart.dart';

class DrinkService {
  final UserSettingsController userSettingsController;
  final DrinkController drinkController;
  final DateService dateService;

  DrinkService({
    required this.userSettingsController,
    required this.drinkController,
    required this.dateService,
  });

  Stream<List<Drink>> get drinksForSelectedDateStream {
    return Rx.combineLatest2(
      drinkController.userRelatedEntitiesStream,
      dateService.selectedDateStream,
      (drinks, selectedDate) {
        final filtered = drinks
            .where((drink) => _isSameDay(drink.consumedAt, selectedDate))
            .toList();
        filtered.sort((a, b) => b.consumedAt.compareTo(a.consumedAt));
        return filtered;
      },
    );
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  Future<void> addDefaultDrink() async {
    final userSettings = await userSettingsController.currentUserSettings;
    await drinkController.createSingle(
      DrinkCreate(
        consumedAt: DateTime.now(),
        drinkType: userSettings.defaultDrinkType,
        volumeInMilliliters: userSettings.defaultDrinkSize,
      ),
    );
  }
}
